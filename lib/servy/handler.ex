defmodule Servy.Handler do
  def handle(request) do
  #  conv = parse(request)
  #  conv = route(conv)
  #  format_response(conv)
    request 
    |> parse 
    |> route 
    |> format_response
  end

  def parse(request) do
 #   first_line = request |> String.split "/n" |> List.first
 #   [method, path, _] = String.split first_line, ""
    [method, path, _] = 
      request
      |> String.split("\n")
      |> List.first
      |> String.split(" ")
    conv = %{ method: method, path: path, resp_body: ""}
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
    %{ conv | resp_body: "Bears, Lions, Tigers"}
  end

  def route(conv, "GET", "/bears") do
    %{ conv | resp_body: "Teddy, Smoll"}
  end

  def format_response(conv) do
  
  """
    HTTP/1.1. 200 OK
    Content-Type: text/html
    COntent-Length: #{String.length(conv.resp_body)}
    #{conv.resp_body}
  """
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
expected_response = """
HTTP/1.1. 200 OK
Content-Type: text/html
COntent-Length: 20

Bears, Lions, TIgers
"""

response = Servy.Handler.handle(request1)

IO.puts response