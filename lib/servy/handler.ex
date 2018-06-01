defmodule Servy.Handler do
  def handle(request) do
  #  conv = parse(request)
  #  conv = route(conv)
  #  format_response(conv)
    request 
    |> parse 
    |> rewrite_path
    |> log
    |> track
    |> route 
    |> format_response
  end

  def track(%{status: 404, path: path} = conv) do
    IO.puts "Warning with path: ${path}"
    conv
  end

  def rewrite_path(%{path: "/wildlife"} = conv) do
    %{ conv | path: "/wildthings"}
  end

  def rewrite_path(conv), do: conv

  def parse(request) do
 #   first_line = request |> String.split "/n" |> List.first
 #   [method, path, _] = String.split first_line, ""
    [method, path, _] = 
      request
      |> String.split("\n")
      |> List.first
      |> String.split(" ")
    %{ method: method, 
      path: path, 
      resp_body: "",
      status: 404
    }
  end
  
  def log(conv), do: IO.inspect conv



  def route(conv) do
    #conv = %{ method: "GET", path: "/wildthings", resp_body: "Bear, Lions, Tigers"}
  #  if conv.path == "/wildthings" do
  #    %{ conv | resp_body: "Bears, Lions, Tigers"}
  #  else 
  #    %{ conv | resp_body: "Teddy, Smoll"}
  #  end
    route(conv, conv.method, conv.path)
  end

  def route(conv, "GET", "/wildthings") do
    %{ conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(conv, "GET", "/bears") do
    %{ conv | status: 200, resp_body: "Teddy, Smoll"}
  end

  def route(conv, "GET", "/bears/" <> id) do
    %{conv | status: 200, resp_body: "Bear #{id}"}
  end
  def route(conv, _method, path) do
    %{ conv | status: 404, resp_body: "No #{path}"}
  end

  def format_response(conv) do
  """
    HTTP/1.1. #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    COntent-Length: #{String.length(conv.resp_body)}
    #{conv.resp_body}
  """
  end
  

  defp status_reason(code) do
  %{
    200 => "OK",
    201 => "Created",
    403 => "Forbidden",
    404 => "Not found",
    500 => "Internal server error"
  }[code]
  end

end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
"""

request1 = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
"""
request2 = """
GET /noPath HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
"""
expected_response = """
HTTP/1.1. 200 OK
Content-Type: text/html
COntent-Length: 20

Bears, Lions, TIgers
"""

response = Servy.Handler.handle(request2)

IO.puts response

request2 = """
GET /bears/2 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
"""

response = Servy.Handler.handle(request2)

IO.puts response