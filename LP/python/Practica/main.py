#!/usr/bin/python
# -*- coding: utf-8 -*-

# from HTMLParser import HTMLParser
# import csv
import math
import re
import urllib2
import xml.etree.ElementTree as ET


events_url = "http://w10.bcn.es/APPS/asiasiacache/peticioXmlAsia?id=199"
weather_url = "http://static-m.meteo.cat/content/opendata/ctermini_comarcal.xml"
bicing_url = "http://wservice.viabicing.cat/v1/getstations.php?v=1"


#------------------------- Funciones auxiliares ------------------------------#
def xml_from_url(url):
    """ Devuelve un xml a partir de una url """
    request = urllib2.Request(url)
    response = urllib2.urlopen(request)
    xml = response.read()
    response.close()
    return ET.fromstring(xml)


def clean_str(string):
    """ Elimina acentos y mayúsculas """
    string = string.encode("utf-8")
    string = re.sub("á", "a", string)
    string = re.sub("à", "a", string)
    string = re.sub("Á", "a", string)
    string = re.sub("À", "a", string)
    string = re.sub("é", "e", string)
    string = re.sub("è", "e", string)
    string = re.sub("É", "e", string)
    string = re.sub("È", "e", string)
    string = re.sub("í", "i", string)
    string = re.sub("Í", "i", string)
    string = re.sub("ï", "i", string)
    string = re.sub("Ï", "i", string)
    string = re.sub("ó", "o", string)
    string = re.sub("ò", "o", string)
    string = re.sub("Ó", "o", string)
    string = re.sub("Ò", "o", string)
    string = re.sub("ú", "u", string)
    string = re.sub("Ú", "u", string)
    return string.lower()


def to_radians(a):
    return float(a) * (math.pi / 180.0)


#-------------------------------- Clases -------------------------------------#
class Event(object):
    """ Representa un evento """

    # para no tener conflicto con las 'ids' intrínsecas de los objetos de python
    # idd = 0
    # nom = ""
    # nom_curt = ""
    # tipus_acte = ""
    # rellevant = ""
    # estat = ""
    # estat_cicle = ""
    # nom_lloc = ""
    # carrer = ""
    # numero = ""
    # districte = ""
    # codi_postal = ""
    # municipi = ""
    # barri = ""
    # lat = ""
    # lon = ""
    # telefons = []
    # fax = []
    # data_proper_acte = ""
    # hora_fi = ""
    # classificacions = []

    def __str__(self):
        return "(%s) %s" % (self.idd, self.nom.encode("utf-8"))

    def __init__(self, xml_event=None):
        """ Creadora que acepta un xml para generar el evento """
        super(Event, self).__init__()
        if xml_event is not None:
            self.__from_xml__(xml_event)

    def __from_xml__(self, xml_event):
        """ Set de los atributos a partir del evento en formato xml """
        self.idd = xml_event.find("id").text
        self.nom = xml_event.find("nom").text
        self.by_name = clean_str(self.nom)
        self.nom_curt = xml_event.find("nom_curt").text
        self.tipus_acte = xml_event.find("tipus_acte").text
        self.rellevant = xml_event.find("rellevant").text
        self.estat = xml_event.find("estat").text
        self.estat_cicle = xml_event.find("estat_cicle").text

        # acceso al hijo "lloc_simple" del xml
        xml_lloc = xml_event.find("lloc_simple")
        if xml_lloc is not None:
            self.nom_lloc = xml_lloc.find("nom").text
            self.by_place = clean_str(self.nom_lloc)

            # acceso al hijo "adreca_simple" del xml
            # que contiene la localizacion
            xml_adreca = xml_lloc.find("adreca_simple")
            if xml_adreca is not None:
                self.carrer = xml_adreca.find("carrer").text
                self.numero = xml_adreca.find("numero").text
                self.districte = xml_adreca.find("districte").text
                self.codi_postal = xml_adreca.find("codi_postal").text
                self.municipi = xml_adreca.find("municipi").text
                self.barri = xml_adreca.find("barri").text
                self.by_neighborhood = clean_str(self.barri)

                # acceso al hijo "coordenades" del xml
                xml_coords = xml_adreca.find("coordenades")
                if xml_coords is not None:
                    map_coords = xml_coords.find("googleMaps")
                    if map_coords is not None:
                        self.lat = map_coords.get("lat")
                        self.lon = map_coords.get("lon")

            # iteración sobre los nodos "telefon" del xml y distinción entre
            # fax y telefono
            self.fax = []
            self.telefons = []
            for xml_telef in xml_lloc.findall(".telefons/telefon"):
                if xml_telef.find("tipus").text == "Fax":
                    self.fax.append(xml_telef.find("numero_telf").text)
                else:
                    self.telefons.append(xml_telef.find("numero_telf").text)

        # acceso al hijo "data" del xml
        data = xml_event.find("data")
        if data is not None:
            self.data_proper_acte = data.find("data_proper_acte").text
            self.hora_fi = data.find("hora_fi").text

        # guardado de las clasificaciones con list comprehension
        self.classificacions = [c.text for c in xml_event.findall("./classificacions/nivell")]

    def matches(self, names_list, places_list, hoods_list):
        """ Devuelve si el evento hace matching con todos los parámetros de las listas """
        for name in names_list:
            if re.search(name, self.by_name) is None:
                return False
        for place in places_list:
            if re.search(place, self.by_place) is None:
                return False
        for hood in hoods_list:
            if re.search(hood, self.by_neighborhood) is None:
                return False
        return True


class Prediction(object):
    """ Representa una predicción metereológica de una comarca """

    def __init__(self, region=None, xml_weather=None):
        """ Creadora que acepta un xml para generar la predicción """
        super(Prediction, self).__init__()
        self.region = region
        self.rain_today = False
        self.rain_tomorrow = False
        if xml_weather is not None:
            self.__from_xml__(xml_weather, region)

    def __from_xml__(self, xml, region):
        """ Genera la predicción a partir del xml """
        id_region = xml.find("*/[@nomCAPITALCO='%s']" % region).get("id")
        prediction_region = xml.findall("*/[@idcomarca='%s']/" % id_region)

        self.pred_morning_today = prediction_region[0].get('probcalamati')
        self.pred_aftern_today = prediction_region[0].get('probcalatarda')
        if self.pred_morning_today != "1" or self.pred_aftern_today != "1":
            self.rain_today = True
        self.min_temp_today = int(prediction_region[0].get('tempmin'))
        self.max_temp_today = int(prediction_region[0].get('tempmax'))

        self.pred_morning_tomorrow = prediction_region[1].get('probcalamati')
        self.pred_aftern_tomorrow = prediction_region[1].get('probcalatarda')
        if self.pred_morning_tomorrow != "1" or self.pred_aftern_tomorrow != "1":
            self.rain_tomorrow = True
        self.min_temp_tomorrow = int(prediction_region[1].get('tempmin'))
        self.max_temp_tomorrow = int(prediction_region[1].get('tempmax'))

    def __str__(self):
        return "(%s) lluvia:%s, temp:%d-%d" % (
            self.region, self.rain_today, self.min_temp_today, self.max_temp_today)


class BicingStation(object):
    """ Representa una estación de bicing """
    # son los nombres de los atributos y el tipo de dato que contienen
    setters = {
        'id': int,
        'street': str,
        'lat': float,
        'long': float,
        'height': str,
        'streetNumber': str,
        'status': str,
        'slots': int,
        'bikes': int,
    }

    def __str__(self):
        return "(%s) %s" % (self.id, self.street)


class BicingStations(dict):
    """ Representa todas las estaciones de bicing """

    def __init__(self, xml_stations=None):
        """ Creadora que admite un xml con la info de las estaciones """
        super(BicingStations, self).__init__()
        if xml_stations is not None:
            self.__from_xml__(xml_stations)

    def __from_xml__(self, xml):
        """ Añade toda las estaciones de bicing contenidas en el xml """
        for station in xml.findall('station'):
            station = BicingStation()
            for k, funct in station.setters.items():
                station.__setattr__(k, funct(station.find(k).text))

            station.nearbyStationList = station.findtext('nearbyStationList')
            self[station.id] = station

    def available(self):
        """ Estaciones con status == OPN """
        return [v for s, v in filter(
            lambda v: v[1].status == "OPN", self.items())]

    def empty(self):
        """ Estaciones vacías """
        return [v for s, v in filter(lambda v: v[1].bikes == 0, self.items())]

    def full(self):
        """ Estaciones llenas """
        return [v for s, v in filter(
            lambda v: v[1].slots == 0, self.items())]

    def few_bikes(self, stations=None):
        """ Estaciones con menos de 5 bicis """
        if not stations:
            stations = self.items()
        return [v for s, v in filter(lambda v: v[1].bikes <= 5 and
                v[1].bikes > 0, stations)]

    def with_bikes(self, stations=None):
        """ Estaciones que contienen alguna bici """
        if not stations:
            stations = self.items()
        return [v for s, v in filter(lambda v: v[1].bikes > 0, stations)]

    def with_slots(self, stations=None):
        """ Estaciones que tienen algún slot """
        if not stations:
            stations = self.items()
        return [v for s, v in filter(lambda v: v[1].slots > 0, stations)]

    def few_slots(self, stations=None):
        """ Estaciones con menos de 5 slots """
        if not stations:
            stations = self.items()
        return [v for s, v in filter(
            lambda v: v[1].slots <= 5 and v[1].slots > 0, stations)]

    def get_nearby(self, id=None):
        """ Estaciones cercanas a la estacion con id 'id' """
        if not id:
            return []
        return self[id].nearbyStationList

    def get_stations_within_radius(self, radius, lat, lon, stations=None):
        """ Devuelve las estaciones que están a menos del radio del punto dado por latitud y longitud """
        if not stations:
            stations = self.items()
        EARTH_RADIUS = 6372.795477598
        lat, lon = to_radians(lat), to_radians(lon)
        ret = []
        for s, v in stations:
            v_lat, v_long = v.lat, v.long
            v_lat, v_long = to_radians(v_lat), to_radians(v_long)
            distance = EARTH_RADIUS * math.acos(math.sin(lat) * math.sin(v_lat) + math.cos(lat) * math.cos(v_lat) * math.cos(lon - v_long))
            if distance <= radius:
                v.distance = int(distance * 1000)
                ret.append((s, v))
        return ret

#-------------------------- Gestión del input --------------------------------#
# "nom:exposicio , barri:Poblenou"
user_input = raw_input("Escribe tu peticion:\n")
# user_input = "nom:ra , nom:posic , barri:Poblenou"
# user_input = "nom: museu"
user_input = user_input.decode("utf-8")
user_input = clean_str(user_input)

# expresiones regulares para coger las listas de atributos
regexp_name = "nom:\s*([\s\w\d·ç’ïüñ@']*)\s*"
regexp_place = "lloc:\s*([\s\w\d·ç’ïüñ@']*)\s*"
regexp_neighborhood = "barri:\s*([\s\w\d·ç’ïüñ@']*)\s*"

# descomposición del input según los atributos pedidos, sin importar el orden
# contiene las peticiones por "nom:"
names = re.findall(regexp_name, user_input)
# contiene las peticiones por "barri:"
neighborhoods = re.findall(regexp_neighborhood, user_input)
# contiene las peticiones por "lloc:"
places = re.findall(regexp_place, user_input)

print names
# print neighborhoods
# print places

# si no hay peticion termina el programa mostrando el formato
if len(names) == 0 and len(neighborhoods) == 0 and len(places) == 0:
    print "Please insert a valid input!\n"
    print "The format is:"
    print " nom: name of the event"
    print " lloc: place of the event"
    print " barri: neighborhood of the event"
    print "Now exiting the program...\n"
    exit(1)

#-----------------------------------------------------------------------------#

#------------------------ Extracción de los eventos --------------------------#
# extracción de los eventos
events_xml = xml_from_url(events_url)

events = dict()
# iteración sobre cada nodo xml 'acte'
for acte_xml in events_xml.findall('.//acte'):
    # instanciación del evento con el xml que contiene la info del evento
    event = Event(acte_xml)
    # addición al diccionario de todos los eventos
    events[event.by_name] = event

#-----------------------------------------------------------------------------#

#--------------------------- Filtrado de eventos  ----------------------------#

# eventos que cumplen todas las condiciones de las 3 listas
matched_events = [e_obj for e_obj in filter(
    lambda e: e.matches(names, places, neighborhoods), events.values())]
if len(matched_events) == 0:
    print "No results have been found for the request:"
    print user_input
else:
    print "Found %d mathing events" % len(matched_events)
    if len(matched_events) < 20:
        for e in matched_events:
            print e

#-----------------------------------------------------------------------------#

#--------------------------- Extracción del clima ----------------------------#

# extraer la información del clima
weather_xml = xml_from_url(weather_url)
prediction_bcn = Prediction("Barcelona", weather_xml)
print "prediction_bcn: %s" % (prediction_bcn)
if not prediction_bcn.rain_today:
    # paradas bicing
    bicing_xml = xml_from_url(bicing_url)
else:
    pass
    # trans publico

#-----------------------------------------------------------------------------#

############################# PSEUDOALGORISMO #################################
# gestionar input OK
# extraccion de los eventos OK
# devolver los que hacen matching OK
# si prevision de lluvia baja:
  # 5 estaciones bicing con sitios <500m ord prox, si no hay -> transp. publico
  # 5 estaciones bicing con bicis <500m ord prox, si no hay -> transp. publico
# si prevision de lluvia no baja (media o alta?):
  # paradas transp. publico <1000m ord prox, no repetir buses, estacion o linea metro
###############################################################################
