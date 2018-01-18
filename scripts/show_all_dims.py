#!/pipedream/local/venv/deepfield-env/bin//python

from pprint import pprint
import deepy.dimensions.ddb as ddb


if __name__ == "__main__":
    db = ddb.get_ddb()
    pprint(sorted(db.dimensions(), key=lambda d:d[1]))
