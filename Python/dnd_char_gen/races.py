from os.path import abspath, dirname, join
from xml.etree.ElementTree import fromstring

import xmljson

"""
needed for Race to start:
    ability_str parsed
    npc_only
    name, parsed
    proficiency parsed
    traits parsed for abiltiy score increases, skills, feat, etc
    
    
    then, add in other data
    and compare/weight to avoid all the dragonborns for example
"""
class Race:
    def __init__(self, name, size, speed, ability, proficiency, trait, spellAbility="", modifier=""):
        self.npc_only = 'npc' in name.lower()
        self.name = name
        self.size = size
        self.speed = speed
        self.ability_str = ability
        self.proficiency = proficiency
        self.trait = trait
        self.spell_ability = spellAbility
        self.modifier = modifier

    def __str__(self):
        pass

    def apply(self, character_obj):
        pass

    def parse_abilities(self, ability_obj):
        entries = self.ability_str.split(',')
        for entry in entries:
            ability_type = entry[:3].upper()
            ability_mod = int(entry[3:].strip())
            ability_obj['stats'][ability_type] += ability_mod


class Universe:
    def __init__(self):
        self.data_folder = join(dirname(abspath(__file__)), 'data')
        self.data = {}

    def load_data(self):
        a = self.load_core()
        a.update(self.load_eberron())
        a.update(self.load_npc_race_data())
        print(a)

    def load_core(self):
        with open(join(self.data_folder, 'Core.xml')) as fin:
            xmldata = fin.read()
        json_data = xmljson.parker.data(fromstring(xmldata))
        return {x['name']: Race(**x) for x in json_data['race']}

    def load_eberron(self):
        with open(join(self.data_folder, 'EberronAddOn.xml')) as fin:
            xmldata = fin.read()
        json_data = xmljson.parker.data(fromstring(xmldata))
        return {x['name']: Race(**x) for x in json_data['race']}

    def load_npc_race_data(self):
        with open(join(self.data_folder, 'NPCRacesAddOn.xml')) as fin:
            xmldata = fin.read()
        json_data = xmljson.parker.data(fromstring(xmldata))
        return {x['name']: Race(**x) for x in json_data['race']}


uni = Universe()
uni.load_data()