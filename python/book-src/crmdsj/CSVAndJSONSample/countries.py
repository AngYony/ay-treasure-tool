from pygal_maps_world.i18n import COUNTRIES
#将键按字母顺序排序并遍历
for country_code in sorted(COUNTRIES.keys()):
    print(country_code,COUNTRIES[country_code])

