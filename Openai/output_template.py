from pydantic import BaseModel
from typing import ClassVar

class ExternalCall(BaseModel):
    direct_external_call: list[str]
    indirect_external_call: list[str]

class ExternalCall_2(BaseModel):
    external_call: list[str]

class StateRead(BaseModel):
    variable: list[str]
    reason: str

class Modifier(BaseModel):
    modifier: list[str]

class Reason(BaseModel):
    explaination: str
    judge: bool

class Transfer(BaseModel):
    Judge: list[Reason]

class gas(BaseModel):
    judge: bool
    gas_value: str
    is_Number: bool

class Gas(BaseModel):
    Judge: list[gas]

class Explaination(BaseModel):
    Reason: str
    judge: str

class key_value_pair(BaseModel):
    key: str
    value: str

class Match(BaseModel):
    result: list[key_value_pair]
