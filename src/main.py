from fastapi import FastAPI
from fastapi.responses import RedirectResponse

app = FastAPI(
    title="uv-docker",
    description="API for uv-docker",
    license_info={
        "name": "MIT",
        "url": "https://raw.githubusercontent.com/rebeccabuchholz/uv-docker/refs/heads/main/LICENSE"
    }
)

@app.get("/", include_in_schema=False)
async def home():
    """Redirect home to docs."""
    return RedirectResponse(url="/docs")

@app.get("/glow-check")
async def glow_check() -> dict[str, str]:
    return {"blacklight": "ON"}