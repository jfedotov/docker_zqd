
import re
import subprocess
import requests

class Version:
    def __init__(self, v: str):
        v = v.lower()
        if 'alpha' in v:
            v = v.replace('alpha', '.0.1.')
        elif 'beta' in v:
            v = v.replace('beta', '.0.2.')
        elif 'rc' in v:
            v = v.replace('rc', '.0.3.')
        else:
            v += '.0.4'
        self._v = re.findall(r'\d+', v)

    def __eq__(self, other):
        return self._v == other._v

    def __ne__(self, other):
        return self._v != other._v

    def __lt__(self, other):
        return self.lt(other)

    def __le__(self, other):
        if self._v == other._v:
            return True
        return self.lt(other)

    def __gt__(self, other):
        return self.gt(other)

    def __ge__(self, other):
        if self._v == other._v:
            return True
        return self.gt(other)

    def lt(self, other):
        if self.l_loop(other):
            return True
        elif self.l_loop(other) == False:
            return False
        else:
            if self.l_len(other):
                return True
            else:
                return False

    def gt(self, other):
        if self.g_loop(other):
            return True
        elif self.g_loop(other) == False:
            return False
        else:
            if self.g_len(other):
                return True
            else:
                return False

    def l_loop(self, o):
        try:
            for i in range(0, len(self._v)):
                if int(self._v[i]) < int(o._v[i]):
                    return True
                elif int(self._v[i]) > int(o._v[i]):
                    return False
            return False
        except IndexError:
            return None

    def g_loop(self, o):
        try:
            for i in range(0, len(self._v)):
                if int(self._v[i]) > int(o._v[i]):
                    return True
                elif int(self._v[i]) < int(o._v[i]):
                    return False
            return False
        except IndexError:
            return None

    def l_len(self, o):
        if len(self._v) < len(o._v):
            return True
        elif len(self._v) > len(o._v):
            return False

    def g_len(self, o):
        if len(self._v) > len(o._v):
            return True
        elif len(self._v) < len(o._v):
            return False


def get_zq_version() -> str:
    resp = requests.get('https://api.github.com/repos/brimsec/zq/releases/latest',
                        headers={'Accept': 'application/vnd.github.v3+json'})
    if resp.status_code == 200:
        resp_json = resp.json()
        if 'tag_name' in resp_json:
            if resp_json['tag_name'].startswith('v'):
                return resp_json['tag_name'][1:]


def get_docker_version() -> str:
    ver_list = []
    resp = requests.get('https://registry.hub.docker.com/v1/repositories/jfedotov/zqd/tags')
    if resp.status_code == 200:
        for j in resp.json():
            if 'name' in j:
                if j['name'].startswith('v'):
                    ver_list.append(j['name'][1:])
    return max(ver_list)


def compile_and_push_new_image(zqversion):
    process = subprocess.Popen(['env', 'ZQVERSION=v' + zqversion, './compile_and_push.sh'],
                               stdout=subprocess.PIPE,
                               universal_newlines=True)

    while True:
        return_code = process.poll()
        if return_code is not None:
            print('RETURN CODE', return_code)
            for output in process.stdout.readlines():
                print(output.strip())
            break


def main():
    zq_version = get_zq_version()
    docker_version = get_docker_version()
    if Version(zq_version) > Version(docker_version):
        print("New zq version is available!")
        print("Building new docker image and push.")
        compile_and_push_new_image(zq_version)
    else:
        print("no new version.")

if __name__ == "__main__":
    main()
