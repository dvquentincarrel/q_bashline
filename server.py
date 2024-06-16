import socketserver
import processor
import socket
import argparse
import os


DEFAULTS = {
    "socket_dir": "{}/{}".format(
        (os.getenv('XDG_RUNTIME_DIR')
            or os.getenv('TMPDIR')
            or '/tmp'),
        "/qbl"),
 }

parser = argparse.ArgumentParser()
parser.add_argument("-p", "--path", default=DEFAULTS['socket'], help=f'Path to the server socket. Defaults to {DEFAULTS["socket"]}')
args = parser.parse_args()

def setup(socket_dir, socket_name):
    if not os.path.exists(socket_dir):
        os.mkdir(socket_dir)
    if os.path.exists(f"{socket_dir}/{socket_name}"):
        os.remove(f"{socket_dir}/{socket_name}")

class Handler(socketserver.BaseRequestHandler):
    def __init__(self, request, client_address, server):
        super().__init__(request, client_address, server)
        self.processor = processor.Processor()
        self.request: socket.socket

    def handle(self):
        """Process request"""
        while True:
            data = self.request.recv(1024)
            self.config(data)
            if not data:  # Client closed its connexion
                break

    def config(self, message: str):
        """Parses the input sent by bash to decide which statusline widget to use"""
        input = message.split(',')
        options = ['use_exit',
                   'use_time',
                   'use_nnn',
                   'use_cwd',
                   'use_git_branch',
                   'use_git_status',
                   'use_async_git']
        for i, opt_name in enumerate(options):
            setattr(self, opt_name, int(input[i]))


setup(args.path, 'socket')
with socketserver.ThreadingUnixStreamServer(f"{socket_dir}/{socket_name}", Handler) as server:
    server.allow_reuse_port = True
    server.serve_forever()
