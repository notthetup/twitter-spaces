---
layout: null
title: (Unofficial) Oxide and Friends Twitter Spaces Podcast
---

# {{site.name}}

## Original at : https://github.com/oxidecomputer/twitter-spaces

{% for post in site.data.episodes %}

### {{ post.title }} ({{ post.date | date: "%Y-%m-%d" }})

**Original Episode:** [{{ post.permalink }}]({{ post.permalink }})

<audio controls=controls preload="auto">
    <source src="{{ post.enclosure }}.mp3" type="audio/mpeg"></source>
</audio>

**Notes:**
<br><br>
{{ post.content | markdownify | strip_html }}
<hr>

{% endfor %}
