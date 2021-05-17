# encoding: utf-8

import sys
import json

FILENAME="results.txt"

if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser(description="script parser")
    parser.add_argument('--for-robot', dest='for_robot', action='store_true')
    parser.add_argument('--for-human', dest='for_robot', action='store_false')
    parser.set_defaults(for_robot=True)
    parsed_args = parser.parse_args()

    for_robot = parsed_args.for_robot

    try:
        with open(FILENAME, "r") as results_file:
            lines = list(results_file)
    except IOError:
        print(u'Нет файла results.txt')

    rps = -1
    latency = -1
    is_latency_ok = False
    is_rps_ok = False

    try:
        rps = float(lines[0].split(':')[1].strip().replace(',', '.'))
    except ValueError:
        if not for_robot:
            print(u'В файле results.txt введите числовое значение для Количества запросов')

    try:
        latency = float(lines[1].split(':')[1].strip().replace(',', '.'))
    except ValueError:
        if not for_robot:
            print(u'В файле results.txt введите числовое значение для Времени ответа')

    if rps == -1 or latency == -1:
        sys.exit(1)

    if 6 < rps < 8:
        is_rps_ok = True

    if 0 < latency < 1:
        latency *= 1000
    if 300 < latency < 400:
        is_latency_ok = True

    if for_robot:
        result = {"allow":[], "deny":[], "task_id": "prometheus", "err": []}

        if is_latency_ok:
            result['allow'].append(f"Проверка на latency пройдена. Latency: {latency} ms")
        else:
            result['deny'].append(f"Проверка на latency не пройдена. Latency: {latency} ms")

        if is_rps_ok:
            result['allow'].append(f"Проверка на rps пройдена. Rps: {rps}")
        else:
            result['deny'].append(f"Проверка на rps не пройдена. Rps: {rps}")
        print(json.dumps(result))
