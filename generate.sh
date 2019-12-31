#! /usr/bin/env bash


post_title() {
    # remove extension
    # snake to title case
    echo "$1" | sed -E -e "s/\..+$//g"  -e "s/_(.)/ \u\1/g" -e "s/^(.)/\u\1/g"
}

post_wrapper() {
    # 1 - post id
    # 2 - post content
    # 3 - date
    title="$( post_title $1 )"
    echo -ne "
    <details class=\"post\">
        <summary>
            <div class=\"date\">$3</div>
            <span class=\"post-link\">$title</span>
        </summary>
        <div class=\"post-text\">
            $2
            <div class="separator"></div>
        </div>
    </details>
    "
}

# meta
echo "
<!DOCTYPE html>
<html lang=\"en\">
<head>
<link rel=\"stylesheet\" href=\"./style.css\">
<meta charset=\"UTF-8\">
<meta name=\"viewport\" content=\"initial-scale=1\">
<meta content=\"#ffffff\" name=\"theme-color\">
<meta name=\"HandheldFriendly\" content=\"true\">
<meta property=\"og:title\" content=\"nerdypepper\">
<meta property=\"og:type\" content=\"website\">
<meta property=\"og:description\" content=\"a static site {for, by, about} me \">
<meta property=\"og:url\" content=\"https://nerdypepper.tech\">
<title>n</title>
" > ./docs/index.html

# body
echo "
<body>
<h1 class=\"heading\">n</h1>
" >> docs/index.html


# begin posts
echo "
<div class=\"posts\">
" >> docs/index.html

# posts
posts=$(ls -t ./posts);
for f in $posts; do
    file="./posts/"$f
    echo "generating post $file"
    id="${file##*/}"    # ill name my posts just fine

    html=$(lowdown "$file")

    # generate posts
    post_date=$(date -r "$file" "+%d/%m %Y")
    post_div=$(post_wrapper "$id" "$html" "$post_date")
    echo -ne "$post_div" >> docs/index.html
    first_visible="0"
done

echo "
</div>
</body>
</html>
" >> docs/index.html
