from http.server import HTTPServer, BaseHTTPRequestHandler

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"Hello from Python container")

if __name__ == "__main__":
    server = HTTPServer(("0.0.0.0", 5000), Handler)
    print("Server running on port 5000")
    server.serve_forever()