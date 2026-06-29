from mutagen.id3 import ID3
tags = ID3('yourfile.mp3')
for key in sorted(tags.keys()):
    print(key, '->', tags[key])
