# -*- coding: utf-8 -*-
import socket
import keyboard
import asyncio
import websockets

async def accept(websocket, path):
    print('Connected!')
    try:
        async for message in websocket:
            print(message)
            text_key = {"s": "s", "r": "r", "d": "d", "le": "left", "ri": "right", "sp": "space", "up": "up", "dw": "down"}.get(message, "error")

            if text_key != "error":
                print('key event:'+text_key)
                keyboard.send(text_key)

            # await websocket.send(message)
    except websockets.ConnectionClosed as exc:
        print('Connection closed')

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.connect(("8.8.8.8", 80))

HOST = s.getsockname()[0]
PORT = 11000

print('Waiting connection.....')

server = websockets.serve(accept, HOST, PORT)
asyncio.get_event_loop().run_until_complete(server)
asyncio.get_event_loop().run_forever()