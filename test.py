import hashlib

hex_str1 = ("deadbeefdeadbeefdeadbeefdeadbeef9f2a1c4b7de03e9a8c1fd0b6247ae9d33cb44e6a11d3f582c7b9e04fd9a182b47d61b3ef50ac7d9a13c4f0e692a14be0")
#033dc881cfa72e015a68c0f9e0db42a7f"
#)
hex_str2 = ("deadbeefdeadbeefdeadbeefdeadbeef9f2a1c4b7de03e9a8c1fd0b6247ae9d33cb44e6a11d3f582c7b9e04fd9a182b47d61b3ef50ac7d9a13c4f0e692a14be033dc881cfa72e015a68c0f9e0db42a7f")

data = bytes.fromhex(hex_str1)
print(hashlib.sha256(data).hexdigest())

data = bytes.fromhex(hex_str2)
print(hashlib.sha256(data).hexdigest())

data = bytes.fromhex(hashlib.sha256(data).hexdigest())
print(hashlib.sha256(data).hexdigest())