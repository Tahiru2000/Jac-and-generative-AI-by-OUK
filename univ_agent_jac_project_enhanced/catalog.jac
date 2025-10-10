# catalog.jac
import: json
import as utils;
import: config

has dict as catalog

function initialize() do
    global catalog
    try:
        catalog = utils.load_json(config.CATALOG_PATH)
    except:
        catalog = { "courses": [], "staff": [] }
    end
end

def lookup_course(str query) -> maybe dict:
    for course in catalog.get("courses", []):
        if query.lower() in course.get("code", "").lower() or query.lower() in course.get("title", "").lower():
            return course
        end
    end
    return None
end

def lookup_staff(str query) -> maybe dict:
    for st in catalog.get("staff", []):
        if query.lower() in st.get("name", "").lower():
            return st
        end
    end
    return None
end
