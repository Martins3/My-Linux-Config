#!/usr/bin/env python3
import json
import urllib.request
import argparse

# Instantiate the parser
parser = argparse.ArgumentParser(description="Optional app description")
parser.add_argument("action", type=str)
parser.add_argument("-c", "--count")

args = parser.parse_args()


def request(action, **params):
    return {"action": action, "params": params, "version": 6}


def invoke(action, **params):
    requestJson = json.dumps(request(action, **params)).encode("utf-8")
    response = json.load(
        urllib.request.urlopen(
            urllib.request.Request("http://127.0.0.1:8765", requestJson)
        )
    )
    if len(response) != 2:
        raise Exception("response has an unexpected number of fields")
    if "error" not in response:
        raise Exception("response is missing required error field")
    if "result" not in response:
        raise Exception("response is missing required result field")
    if response["error"] is not None:
        raise Exception(response["error"])
    return response["result"]


match args.action:
    case "add":
        note = {
            "deckName": "martins3",
            "modelName": "Basic",
            "fields": {"Front": "hihi", "Back": "hi"},
            "options": {"allowDuplicate": False},
            "tags": [],
        }
        result = invoke("addNote", note=note)
        print("got list of decks: {}".format(result))
    case "show":
        result = invoke("findNotes", query="deck:martins3")
        for i in result:
            note = invoke("notesInfo", notes=[i])
            print(f"{i} : {note[0]['fields']['Front']['value']}")
    case "delete":
        print(args.count)
        note = invoke("deleteNotes", notes=[args.count])
        print(note)
