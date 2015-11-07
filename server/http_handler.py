class HttpHandler(object):
	def __init__(self, method, path):
		self.method = method
		self.path = path

	def handle_request(self, request):
		if self.path == request["PATH_INFO"] and self.method == request["REQUEST_METHOD"]:
			return "200 OK", "Method handled"
		else:
			return "404 Not found", "Not found"


def handle():
	pass 