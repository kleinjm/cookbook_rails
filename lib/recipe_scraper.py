from recipe_scrapers import scrape_me
import sys
import json

try:
    scraper = scrape_me(str(sys.argv[1]))

    data = {
        "title": scraper.title(),
        "total_time": scraper.total_time(),
        "ingredients": scraper.ingredients(),
        "instructions": scraper.instructions()
    }

    # print(scraper.title())

    with open('tmp/recipe_data.json', 'w', encoding='utf-8') as outfile:
        json.dump(data, outfile)
except:
    print("Error while scraping recipe", sys.exc_info())
