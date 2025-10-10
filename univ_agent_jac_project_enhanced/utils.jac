# utils.jac
import: json
import as os;
import: time

function load_json(str path) -> dict:
    with open(path, "r") as f:
        return json.load(f)

function save_json(str path, dict_obj):
    with open(path, "w") as f:
        json.dump(dict_obj, f, indent=2)

function escape_html(str s) -> str:
    return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")

function log_interaction(str session, str query, str answer):
    t = time.strftime("%Y-%m-%d %H:%M:%S", time.gmtime())
    with open("interaction.log", "a") as f:
        f.write(f"{t}\t{session}\t{query}\t{answer}\n")
