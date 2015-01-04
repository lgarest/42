#!/usr/bin/python
# -*- coding: utf-8 -*-

# from HTMLParser import HTMLParser
from collections import OrderedDict
import codecs
import csv
import math
import re
import urllib2
import xml.etree.ElementTree as ET


events_url = "http://w10.bcn.es/APPS/asiasiacache/peticioXmlAsia?id=199"
weather_url = "http://static-m.meteo.cat/content/opendata/ctermini_comarcal.xml"
bicing_url = "http://wservice.viabicing.cat/v1/getstations.php?v=1"


#------------------------- Funciones auxiliares ------------------------------#

def xml_from_url(url, local=False):
    """ Devuelve un xml a partir de una url """
    if not local:
        request = urllib2.Request(url)
        response = urllib2.urlopen(request)
    else:
        response = open(url)
    xml = response.read()
    response.close()
    return ET.fromstring(xml)


def get_distance(a_lat, a_lon, b_lat, b_lon):
    """ Devuelve si b está dentro del radio de a y la distancia a la que está """
    def to_radians(a):
        """ Transforma a radianes """
        return float(a) * (math.pi / 180.0)

    earth_radius = 6372795.477598
    aux = float(math.pi) / float(180.0)
    a_lat, a_lon = float(a_lat), float(a_lon)
    b_lat, b_lon = float(b_lat), float(b_lon)
    distance = 2 * earth_radius * math.asin(math.sqrt(
        math.sin(aux * abs(b_lat - a_lat) / 2) ** 2 +
        math.cos(aux * a_lat) *
        math.cos(aux * b_lat) *
        math.sin(aux * abs(b_lon - a_lon) / 2) ** 2))
    return int(distance)


def get_bus_transports(bus_list=[], transports_list=[]):
    """ Devuelve dos diccionarios:
        uno con las paradas de bus
        y otro con las de transporte público """

    csv.register_dialect("custom_dialect", CustomDialect)
    bus_list = csv.DictReader(
        open("ESTACIONS_BUS.csv"), dialect="custom_dialect")
    transports_list = csv.DictReader(
        open("TRANSPORTS.csv"), dialect="custom_dialect")
    return bus_list, transports_list


def clean_str(string):
    """ Elimina acentos y mayúsculas """
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


def replace_in_html(html, string, value):
    """ Reemplaza en el html, el string que haga matching por el valor value """

    # se llama para la lista de estaciones de un evento, así que se devuelve el html
    if string == "stations_with_slots" or string == "stations_with_bikes":
        return html

    # en caso de que no se haya extraído el valor
    if value is None:
        value = u""

    # si son strings y no están en unicode se transforman
    if not isinstance(html, unicode) and isinstance(html, str):
        html = unicode(html, "utf-8", errors='replace')
    if not isinstance(string, unicode) and isinstance(string, str):
        string = unicode(string, "utf-8", errors='replace')
    if not isinstance(value, unicode) and isinstance(value, str):
        value = unicode(value, "utf-8", errors='replace')

    try:
        # si es una lista se devuelve un unicode con los elementos concatenados
        if isinstance(value, list):
            value = u', '.join([x for x in value])
        if isinstance(value, (str, unicode)):
            return re.sub("{{" + string + "}}", value, html, re.UNICODE)
        return re.sub("{{" + string + "}}", str(value), html)
    # capturamos las excepciones
    except UnicodeEncodeError:
        print "** UnicodeEncodeError var: %s value: %s" % (string, value)
    except UnicodeDecodeError:
        print "** UnicodeDecodeErrorvar: %s value: %s" % (string, value)
    return html


def load_template(template_name):
    """ Devuelve el contenido del template """
    try:
        file_name = "templates/" + template_name + ".html"
        file = codecs.open(file_name, 'r', 'utf-8')
        template_content = file.read()
        file.close()
        print "%s loaded" % (file_name)
        return template_content
    except:
        print "el fichero %s no existe" % (file_name)
        return None

#-----------------------------------------------------------------------------#

#-------------------------------- Clases -------------------------------------#


class Event(object):
    """ Representa un evento """
    stations_with_slots = []
    stations_with_bikes = []
    lat = ""
    lon = ""

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
        self.lat = 0.0
        self.lon = 0.0

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
        self.public_trans = {}

    def __add_to_public_transport(self, station):
        """ Añade la estación de transporte público al diccionario de estaciones del evento """

        def __get_ids(station_name):
            """ Descompone un nombre de estación en las líneas que contiene para evitar estaciones o líneas repetidas """
            station_name = unicode(station_name, 'utf-8', errors='replace')
            # obtención de las líneas de metro
            regexp_metro = u"\s*METRO\s*(.*)"
            metro_match = re.findall(regexp_metro, station_name)
            if len(metro_match) != 0:
                regexp_metro = u"(L\d+)"
                return "metro", re.findall(regexp_metro, metro_match[0])

            # obtención de las líneas de bus (nit, aero, normal)
            regexp_bus = u"\s*[AERONIT]?BUS\s*(.*)"
            bus_match = re.findall(regexp_bus, station_name)
            if len(bus_match) != 0:
                regexp_bus = u"-(\w?\d+)"
                return "bus", re.findall(regexp_bus, bus_match[0])

            # obtención de las líneas y estaciones de FGC
            regexp_fgc = u"\s*FGC\s*(.*)"
            fgc_match = re.findall(regexp_fgc, station_name)
            if len(fgc_match) != 0:
                regexp_fgc = u"(L\d+)"
                fgc_match2 = re.findall(regexp_fgc, fgc_match[0])
                if len(fgc_match2) == 0:
                    return "ferrocarril", [station_name]
                return "ferrocarril", fgc_match2

            # obtención de las líneas y estaciones de tranvía
            regexp_tram = u"\s*TRAMVIA\s*(.*)"
            tram_match = re.findall(regexp_tram, station_name)
            if len(tram_match) != 0:
                regexp_tram = u"(T\d+)"
                tram_match2 = re.findall(regexp_tram, tram_match[0])
                if len(tram_match2) == 0:
                    return "tramvia", [station_name]
                return "tramvia", tram_match2
            return "otros", [station_name]

        # por cada bus, comprobación de si está dentro del radio
        # y obtención de su distancia
        distance = get_distance(
            self.lat, self.lon,
            station["LATITUD"], station["LONGITUD"])

        if distance < 1000:
            tipus, ids = __get_ids(station["EQUIPAMENT"])
            # por cada línea/estación obtenida
            for ide in ids:
                elem = {
                    "tipus": tipus,
                    "linea": ide,
                    "distance": distance,
                    "lat": station["LATITUD"],
                    "lon": station["LONGITUD"]
                }
                if ide not in self.public_trans.keys():
                    self.public_trans[ide] = elem
                elif ide in self.public_trans.keys():
                    aux = self.public_trans[ide]
                    if elem['distance'] < aux['distance']:
                        self.public_trans[ide] = elem

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

    def get_stations(self, radius, buses=[], trans=[]):
        """ Atribuye las ĺineas de bus y metro al evento """

        buses_copy, trans_copy = buses, trans

        # añadimos los buses y metros al diccionario de transporte público
        map(self.__add_to_public_transport, buses_copy)
        map(self.__add_to_public_transport, trans_copy)

        if self.public_trans is not None:
            # ordenamos el diccionario de metros, tren, tranvia por proximidad
            self.public_trans = OrderedDict(
                sorted(self.public_trans.items(), key=lambda t: t[1]["distance"]))


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
        self.simb_morning_today = int(prediction_region[0].get('simbolmati')[0])
        self.simb_aftern_today = int(prediction_region[0].get('simboltarda')[0])
        if self.pred_morning_today != "1" or self.pred_aftern_today != "1" or self.simb_morning_today > 4 or self.simb_aftern_today > 4:
            self.rain_today = True
        self.min_temp_today = int(prediction_region[0].get('tempmin'))
        self.max_temp_today = int(prediction_region[0].get('tempmax'))
        self.data = prediction_region[0].get('data')

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
        for station_xml in xml.findall('station'):
            station = BicingStation()
            for k, funct in station.setters.items():
                station.__setattr__(k, funct(station_xml.find(k).text))

            station.distance = 20000
            station.nearbyStationList = station_xml.findtext('nearbyStationList')
            self[station.id] = station

    def with_bikes(self, stations=None):
        """ Estaciones que contienen alguna bici """
        return [v for s, v in filter(lambda v: v[1].bikes > 0, stations)]

    def with_slots(self, stations=None):
        """ Estaciones que tienen algún slot """
        return [v for s, v in filter(lambda v: v[1].slots > 0, stations)]


def get_stations_within_radius(radius, lat, lon, stations):
    """ Devuelve las estaciones que están a menos del radio (metros) del punto dado por lat y lon """
    ret = []
    for s, v in stations:
        distance = get_distance(lat, lon, v.lat, v.long)
        v.distance = int(distance)
        if v.distance < radius:
            ret.append((s, v))
    return ret


class CustomDialect(csv.Dialect):
    """ Nuevo dialecto del csv para admitir punto y coma ';' como separadores """
    lineterminator = '\n'
    escapechar = '\\'
    skipinitialspace = False
    quotechar = '"'
    quoting = csv.QUOTE_ALL
    delimiter = ';'
    doublequote = True

#-----------------------------------------------------------------------------#

#-------------------------- Gestión del input --------------------------------#
# "nom:exposicio , barri:Poblenou"
# user_input = raw_input("Escribe tu peticion:\n")
user_input = u"barri:eixample"
# user_input = u"nom:selecció natural, nom:estèreo"
orig_input = user_input
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
# events_xml = xml_from_url(events_url)
events_xml = xml_from_url("events.xml", True)

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
# si no hay resultados salimos
if len(matched_events) == 0:
    print "No se han encontrado resultados para la petición:"
    print user_input
    exit(1)
else:
    print "Encontrados %d eventos, mostrando hasta 20 resultados por terminal" % len(matched_events)
    for e in matched_events[:20]:
        print e

#-----------------------------------------------------------------------------#

#------------- Extracción del clima y gestión de la información --------------#

# extraer la información del clima
weather_xml = xml_from_url(weather_url)
prediction_bcn = Prediction("Barcelona", weather_xml)
print "prediction: %s" % (prediction_bcn)
transports = []
bus_stations = []
if not prediction_bcn.rain_today:
    # paradas bicing
    bicing_xml = xml_from_url(bicing_url)
    for event in matched_events:
        bicing_stations = BicingStations(bicing_xml)
        # estaciones de bicing a menos de 500 m
        nearby_stations = get_stations_within_radius(
            radius=500,
            lat=float(event.lat),
            lon=float(event.lon),
            stations=bicing_stations.items())

        # estaciones de bicing a menos de 500 m con espacios
        event.stations_with_slots = bicing_stations.with_slots(
            stations=nearby_stations)
        # las ordenamos por proximidad y nos quedamos con las 5 primeras
        event.stations_with_slots = sorted(event.stations_with_slots, key=lambda x: x.distance)[:5]

        # estaciones de bicing a menos de 500 m con bicis
        event.stations_with_bikes = bicing_stations.with_bikes(
            stations=nearby_stations)
        # las ordenamos por proximidad y nos quedamos con las 5 primeras
        event.stations_with_bikes = sorted(event.stations_with_bikes, key=lambda x: x.distance)[:5]

        # si no hay estaciones de bicing, obtenemos transporte publico
        if len(event.stations_with_bikes) != 0 or len(event.stations_with_slots) == 0:
            bus_stations, transports = get_bus_transports(bus_stations, transports)
            event.get_stations(radius=1000, buses=bus_stations, trans=transports)

else:
    # trans publico
    bus_stations, transports = get_bus_transports(bus_stations, transports)
    for event in matched_events:
        event.get_stations(radius=1000, buses=bus_stations, trans=transports)

#-----------------------------------------------------------------------------#


#--------------------------- Generación del html -----------------------------#

# carga de los templates originales
home_raw_html = load_template("index")
bicing_raw_html = load_template("bicing_station")
event_raw_html = load_template("event")
pred_html = load_template("prediction")
public_trans_raw_html = load_template("public_station")

# Populación en el template home
home_raw_html = replace_in_html(home_raw_html, "input", orig_input)
home_raw_html = replace_in_html(home_raw_html, "number_of_events", len(matched_events))

for key, value in prediction_bcn.__dict__.items():
    pred_html = replace_in_html(pred_html, key, value)
home_raw_html = replace_in_html(home_raw_html, "prediction", pred_html)

events_html = u""
for event in matched_events:
    event_html = event_raw_html
    for key, value in event.__dict__.items():
        event_html = replace_in_html(event_html, key, value)

    if len(event.stations_with_slots) != 0:
        bicing_list_html = u""
        # inserción de las estaciones con sitio
        for bicing_station in event.stations_with_slots:
            bicing_html = bicing_raw_html
            # inserción en el html de los atributos
            for key, value in bicing_station.__dict__.items():
                bicing_html = replace_in_html(bicing_html, key, value)
            bicing_list_html = u''.join((bicing_list_html, bicing_html))
        event_html = replace_in_html(
            event_html, "stations_with_slots_list", bicing_list_html)
    else:
        # si no hay bicis se muestra un mensaje
        event_html = replace_in_html(event_html, "stations_with_slots_list", u"No hay estaciones de bicing con sitios a menos de 500m, se mostrará el transporte público disponible a menos de 1km")

    if len(event.stations_with_bikes) != 0:
        bicing_list_html = u""
        # inserción de las estaciones con bicis
        for bicing_station in event.stations_with_bikes:
            bicing_html = bicing_raw_html
            # inserción en el html de los atributos
            for key, value in bicing_station.__dict__.items():
                bicing_html = replace_in_html(bicing_html, key, value)
            bicing_list_html = u''.join((bicing_list_html, bicing_html))
        event_html = replace_in_html(
            event_html, "stations_with_bikes_list", bicing_list_html)
    else:
        # si no hay bicis se muestra un mensaje
        event_html = replace_in_html(event_html, "stations_with_bikes_list", u"No hay estaciones de bicing con bicis a menos de 500m, se mostrará el transporte público disponible a menos de 1km")

    if event.public_trans is not None:
        public_transport_stations_html = u""
        # inserción de las estaciones públicas
        for station_name, public_station in event.public_trans.items():
            public_station_html = public_trans_raw_html
            # inserción en el html de los atributos
            for key, value in public_station.items():
                public_station_html = replace_in_html(
                    public_station_html, key, value)

            public_transport_stations_html += public_station_html
        event_html = replace_in_html(
            event_html, "public_trans_list", public_transport_stations_html)
    else:
        # si no hay estaciones de transporte publico se muestra un mensaje
        event_html = replace_in_html(
            event_html, "public_trans_list", u"No hay estaciones de transporte público")

    if event_html is not None:
        events_html = u''.join((events_html, event_html))


home_raw_html = replace_in_html(home_raw_html, "events_list", events_html)
f = codecs.open('home.html', 'w', 'utf-8')
f.write(home_raw_html)
f.close()
print "El archivo 'home.html' se ha generado."

input_str = raw_input("Quieres abrir la página en el navegador?: (s/n) \n")
if clean_str(input_str) == 's':
    import webbrowser
    webbrowser.open('home.html')
print "Bye!"

#-----------------------------------------------------------------------------#

############################# PSEUDOALGORISMO #################################
# gestionar input OK
# extraccion de los eventos OK
# devolver los que hacen matching OK
# si prevision de lluvia baja: OK
  # 5 estaciones bicing con sitios <500m ord prox, si no hay -> transp. publico
  # 5 estaciones bicing con bicis <500m ord prox, si no hay -> transp. publico
# si prevision de lluvia no baja (media o alta?): OK
  # paradas transp. publico <1000m ord prox, no repetir buses, estacion o linea metro
# escribir toda la info en un html OK
###############################################################################
