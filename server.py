# websocket_server.py
import asyncio
import websockets
import json

async def handler(websocket, path):
    async for message in websocket:
        data = json.loads(message)
        if data["type"] == "login":
            result = {
                "type": "loginResult",
                "success": data["username"] == "admin" and data["password"] == "123"
            }
            await websocket.send(json.dumps(result))

start_server = websockets.serve(handler, "localhost", 12345)
asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()
