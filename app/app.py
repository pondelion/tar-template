from fastapi import FastAPI
import pandas as pd

app = FastAPI()


@app.get("/")
def read_root():
    return {"version": "1"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: str = None):
    return {"item_id": item_id, "q": q}


@app.get("/stocklist")
def read_stocklist():
    df = pd.read_csv('s3://fin-app/stocklist/stocklist_latest.csv')
    return {'stocklist': df['銘柄名'].tolist()}
