#!/usr/bin/python
# -*- coding: utf-8 -*-

# from HTMLParser import HTMLParser
# import csv
# import math
import re
import urllib2
import xml.etree.ElementTree as ET


def xml_from_url(url):
    """ Devuelve un xml a partir de una url """
    request = urllib2.Request(url)
    response = urllib2.urlopen(request)
    xml = response.read()
    response.close()
    return ET.fromstring(xml)


def clean_str(string):
    # ostring = string
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
    string = re.sub("ç", "c", string)
    string = re.sub("Ç", "c", string)
    string = re.sub("ñ", "n", string)
    string = re.sub(ur"\xc2\x92", "'", string)
    string = re.sub(ur"\xc2\xb7", "", string)
    string = re.sub("Ñ", "n", string)
    string = re.sub("\*", " ", string)
    # print ostring
    # print " -> " + string.lower() + " " + str(type(string))
    return string.lower()


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
        return "(%s) %s" % (self.idd, self.nom)

    def __init__(self, xml_event):
        super(Event, self).__init__()
        self.__from_xml__(xml_event)

    def __from_xml__(self, xml_event):
        """ set de los atributos a partir del evento en formato xml """

        self.idd = xml_event.find("id").text
        self.nom = xml_event.find("nom").text
        self.by_name = clean_str(self.nom)
        self.nom_curt = xml_event.find("nom_curt").text
        self.tipus_acte = xml_event.find("tipus_acte").text
        self.rellevant = xml_event.find("rellevant").text
        self.estat = xml_event.find("estat").text
        self.estat_cicle = xml_event.find("estat_cicle").text

        # accedemos al hijo "lloc_simple" del xml
        xml_lloc = xml_event.find("lloc_simple")
        if xml_lloc is not None:
            self.nom_lloc = xml_lloc.find("nom").text
            self.by_place = clean_str(self.nom_lloc)

            #accedemos al hijo "adreca_simple" del xml
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

                # accedemos al hijo "coordenades" del xml
                xml_coords = xml_adreca.find("coordenades")
                if xml_coords is not None:
                    map_coords = xml_coords.find("googleMaps")
                    if map_coords is not None:
                        self.lat = map_coords.get("lat")
                        self.lon = map_coords.get("lon")

            # iteramos sobre los nodos "telefon" del xml  y distinguimos entre
            # fax y telefono
            self.fax = []
            self.telefons = []
            for xml_telef in xml_lloc.findall(".telefons/telefon"):
                if xml_telef.find("tipus").text == "Fax":
                    self.fax.append(xml_telef.find("numero_telf").text)
                else:
                    self.telefons.append(xml_telef.find("numero_telf").text)

        # accedemos al hijo "data" del xml
        data = xml_event.find("data")
        if data is not None:
            self.data_proper_acte = data.find("data_proper_acte").text
            self.hora_fi = data.find("hora_fi").text

        # guardamos las clasificaciones con list comprehension
        self.classificacions = [c.text for c in xml_event.findall("./classificacions/nivell")]


events_url = "http://w10.bcn.es/APPS/asiasiacache/peticioXmlAsia?id=199"
bicing_url = "http://wservice.viabicing.cat/v1/getstations.php?v=1"
weather_url = "http://static-m.meteo.cat/content/opendata/ctermini_comarcal.xml"
#### Extracción de los eventos
# primero extraer los eventos
events_xml = xml_from_url(events_url)

events = dict()
# iteramos sobre cada no90do xml 'acte'
for acte_xml in events_xml.findall('.//acte'):
    # instanciamos el evento y populamos sus atributos con el xml que contiene
    # la informacion del evento
    event = Event(acte_xml)
    # lo guardamos en el diccionario de todos los eventos
    events[event.by_name] = event

#### Gestión del input
# gestionamos el input
# "nom:exposicio , barri:Poblenou"
user_input = raw_input("Escribe tu peticion:\n")
# user_input = "nom:exPosIció de la parra, nom:exposicio , barri:Poblenou, barri:Pesca"
user_input = user_input.decode("utf-8")
user_input = clean_str(user_input)
# print user_input

# coger las tres listas, nombres, sitios, barrios
regexp_name = "nom:\s*([\s\w\d]*)\s*"
regexp_place = "lloc:\s*([\s\w\d]*)\s*"
regexp_neighborhood = "barri:\s*([\s\w\d]*)\s*"

names = re.findall(regexp_name, user_input)
neighborhoods = re.findall(regexp_neighborhood, user_input)
places = re.findall(regexp_place, user_input)

# print names
# print neighborhoods
# print places

# devolver los que cumplen los tres objetivos
if len(names) == 0 and len(neighborhoods) == 0 and len(places) == 0:
    print "Please insert a valid input!\n"
    print "The format is:"
    print " nom: name of the event"
    print " lloc: place of the event"
    print " barri: neighborhood of the event"
    print "Now exiting the program...\n"
    exit(1)

def event_in_list(events, list, attr):
    # WIP funcion filtro eventos que cumplen todas las condiciones del atributo


# matched_events = []
for event_name, event in events.items():
    valid = True
    for requested_name in names:
        if re.search(requested_name, event.by_name) is not None:
            print event.by_name
            print "no hace matching"
            break




    # for x in filter(lambda w: w in a, xyz):

    # for attr in (a for a in dir(event) if not a.startswith('_')):
    #     print "%s: %s" % (attr, event.__getattribute__(attr))



# extraemos los xmls de las urls
# bicing_xml = xml_from_url(bicing_url)
# weather_xml = xml_from_url(weather_url)

############################# PSEUDOALGORISMO #################################
# pillar eventos
# gestionar input
# devolver los que hacen matching
# si prevision de lluvia baja:
# 5 estaciones bicing con sitios <500m ord prox, si no hay -> transp. publico
# 5 estaciones bicing con bicis <500m ord prox, si no hay -> transp. publico
# si prevision de lluvia no baja:
# paradas transp. publico <1000m ord prox, no repetir buses, estacion o linea metro
###############################################################################
