import requests as r
from bs4 import BeautifulSoup as bs

filename = 'weather.csv'
file = open(filename, 'w')

s = "DAY;TEMPERATURE;PRECIPITATION\n"
file.write(s)

url = 'https://www.yahoo.com/news/weather/japan/tokyo-prefecture/tokyo-1118370'
response = r.get(url)
page = response.content

soup = bs(page, 'html.parser')
findInfo = soup.find('div', class_='accordion')

for i in findInfo.find_all('div', class_='BdB'):
    day = i.find('div').find('span').get_text()
    temp = i.find('span', class_='high').get_text()
    rain = i.find('span', class_='M(5px)').get_text()
    forecast = day+';'+temp+';'+rain+'\n'
    file.write(forecast)

file.close()