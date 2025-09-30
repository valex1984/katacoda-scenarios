from gigachat import GigaChat

domain = open("/usr/local/etc/sbercode-ingress", "r").read()
token = open("/usr/local/etc/proxy-key", "r").read()
baseurl = f"https://{domain}/proxy/api/v1/gigachat/"

with GigaChat(access_token=token, base_url=baseurl) as giga:
    response = giga.get_models()
    print(response)


# with GigaChat(access_token=token, base_url=baseurl) as giga:
#     response = giga.chat("Как дела?")
#     print(response)