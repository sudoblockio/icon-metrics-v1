from fastapi.testclient import TestClient
from sqlalchemy.orm import Session

from icon_metrics.config import settings
from icon_metrics.workers.supply_cron import get_supply


def test_api_get_supply(db: Session, client: TestClient, run_process_wait):
    with db as session:
        get_supply(session)
        response = client.get(f"{settings.REST_PREFIX}/metrics/supply")
        assert response.status_code == 200
        supply = response.json()
        assert isinstance(supply, dict)
        assert supply["circulating_supply"] > 1e24


# def test_api_get_node_state(db: Session, client: TestClient):
#     response = client.get(f"{settings.REST_PREFIX}/metrics/node-state")
#     assert response.status_code == 200
#     states = response.json()
#     assert isinstance(states, list)
