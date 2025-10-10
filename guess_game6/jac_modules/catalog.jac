# catalog.jac
import json
from utils import load_json

has dict catalog

function initialize() do
    try:
        catalog = load_json(config.CATALOG_PATH)
    except:
        catalog = { "courses": [], "staff": [] }
    end
end

function lookup_course(str query) -> maybe dict:
    for course in catalog.get("courses", []):
        if query.lower() in course.get("code", "").lower() or query.lower() in course.get("title", "").lower():
            return course
        end
    end
    return None
end

function lookup_staff(str query) -> maybe dict:
    for st in catalog.get("staff", []):
        if query.lower() in st.get("name", "").lower():
            return st
        end
    end
    return None
end
