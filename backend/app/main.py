from fastapi import FastAPI
from app.routes import products
from app.routes import auth, users, cart, favorite, orders, banners, categories, filters, countries
from app.db import init_db

app = FastAPI(title="Furniture Backend")


@app.on_event("startup")
def on_startup():
    # create tables in dev; production should use alembic migrations
    init_db()


app.include_router(products.router, prefix="/products", tags=["products"]) 
app.include_router(auth.router, prefix="/auth", tags=["auth"])
app.include_router(users.router, prefix="/users", tags=["users"])
app.include_router(cart.router, prefix="/cart", tags=["cart"])
app.include_router(favorite.router, prefix="/favorites", tags=["favorites"])
app.include_router(orders.router, prefix="/orders", tags=["orders"])
app.include_router(banners.router, prefix="/banners", tags=["banners"])
app.include_router(categories.router, prefix="/categories", tags=["categories"])
app.include_router(filters.router, prefix="/filters", tags=["filters"])
app.include_router(countries.router, prefix="/countries", tags=["countries"])


@app.get("/")
def root():
    return {"status": "ok", "service": "furniture-backend"}
