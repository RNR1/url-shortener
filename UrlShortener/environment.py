import json
import boto3
from typing import Generic, Type, TypeVar
from decouple import config

AutoCast = TypeVar("AutoCast")


class EnvVar(Generic[AutoCast]):
    secrets: dict[str, str] = {}

    def __init__(self, secret_id: str = None) -> None:
        if secret_id:
            sm = boto3.client(
                service_name='secretsmanager',
                region_name=config('REGION_NAME', default='us-east-1')
            )
            get_secret_value_response = sm.get_secret_value(
                SecretId=secret_id)
            self.secrets = json.loads(
                get_secret_value_response['SecretString'])
        super().__init__()

    def load(
        self, key: str, *, cast: Type[AutoCast] = str,
        default: AutoCast | None = None, secrets_key: str = None,
    ) -> AutoCast:
        result = config(
            key, default=self.secrets.get(secrets_key or key, default), cast=cast
        )
        if result is None:
            raise ValueError(f"Missing required environment variable: {key}")
        return result
