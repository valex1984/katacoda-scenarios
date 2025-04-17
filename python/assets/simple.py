from gigachat import GigaChat

domain = open("/usr/local/etc/sbercode-ingress", "r").read()
baseurl = f"https://{domain}/proxy/api/v1/gigachat/"

with GigaChat(
        access_token="a89466f3-53e9-4fda-b00d-eb36dbea21eb",
        base_url=baseurl
        ) as giga:
    response = giga.get_models()
    print(response)