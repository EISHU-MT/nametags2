# Nametags 2
Set to the entities a new type of nametag, based on WayPoints and on Observers List, Color and string style "\n"

## API
The API is easy to use:

### Functions
- `dnt_api.register_nametag(name_of_nt, definition):`  **Register new nametag<br>def = {obj=Object, text="string", range=10, players={Catars=true}, color=0x0}<br>name_of_nt = "string, name/id of nametag"**
- `dnt_api.insert_player(name_of_nt, player):` **Add a new player in the nametag<br>player = PlayerObj<br>name_of_nt = "string, name/id of nametag"**
- `dnt_api.update_hard_players(name_of_nt, players):` **Reset 'nametag' players table and set a new player table<br>name_of_nt = "string, name/id of nametag"<br>players = {Player1 = true, Player2 = true} --New players table**
- `dnt_api.remove_player(name_of_nt, NameObj):` **Remove a player from 'nametag' players table<br>NameObj = PlayerObject or PlayerName<br>name_of_nt = "string, name/id of nametag"**
- `dnt_api.remove_dynamic_nametag(name_of_nt):` **Remove nametag<br>name_of_nt = "string, name/id of nametag"**
### Global Tables<br>There are 3 defined global tables for nametags:
- `dnametag:` **This table stores all registered NameTags definitions**
- `dnt_api:` **This table have the API of NameTags**
- `dnthud:` **WayPoint Definition (Used to register NameTags)**
## How NameTags works
Nametags works from **WayPoints** on huds. Every **NameTag** has **WayPoint** for each player, that updates on every server step (From Object Pos)

## License
Its **MIT**

## Notes
1. This mod may produce lag
2. This mod on every server step updates the nametags (As Pos/Text/Color) for each object and player
