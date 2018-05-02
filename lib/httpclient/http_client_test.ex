defmodule HttpClient do


  def get(url) do
    HTTPotion.get("#{url}")
  end
  
end