
#!/bin/bash

display_greeting() {
    echo """
     __ __                 _                  _        _             _
|  \  \ ___  _ _ ._ _ <_>._ _  ___   _ _ <_> ___ _| |_ ___  _ _ | |
|     |/ . \| '_>| ' || || ' |/ . | | | || |/ | ' | | / . \| '_>|_/
|_|_|_|\___/|_|  |_|_||_||_|_|\_. | |__/ |_|\_|_. |_| \___/|_|  <_>
                              <___'
    """
}

fetch_a_read_article() {
    # Use grep with basic regular expressions to extract URLs from the markdown file
    grep -E -o -h '\b((https?|ftp|file):\/\/[-A-Za-z0-9+&@#\/%?=~_|!:,.;]*[-A-Za-z0-9+&@#\/%=~_|])' ~/garden.md ~/worklog.md ~/todo.md | sort -R | head -n 1
}

verse() {
  fout=/tmp/verse.html
  wget --quiet https://www.verseoftheday.com/ --output-document=$fout
  verse=$(cat $fout | pup '.scripture' 'text{}')
  # HTML decode
  echo $verse | sed 's/&nbsp;/ /g; s/&amp;/\&/g; s/&lt;/\</g; s/&gt;/\>/g; s/&quot;/\"/g; s/&#34;/\"/g; s/&#39;/\'"'"'/g; s/&ldquo;/\"/g; s/&rdquo;/\"/g; s/â€”/-/g'
}

get_a_good_read() {
    reads=("https://seroter.com/" "https://www.goodtechthings.com/" "https://www.news.aakashg.com/" "https://github.com/mtdvio/every-programmer-should-know?tab=readme-ov-file" "https://javarevisited.blogspot.com/2014/05/10-articles-every-programmer-must-read.html#axzz8SJx4t05l" "https://news.ycombinator.com/item?id=7743952")
    len=${#reads[@]}
    randind=$((RANDOM % len))
    echo ${reads[randind]}
}

get_a_todo() {
    grep "\s*- \[ \]" ~/todo.md | sed "s/\s*- //" | sort -R | head -n 1
}

vim_tip() {
    open https://vim.fandom.com/wiki/Best_Vim_Tips
}

# Function to display the menu options
display_menu() {
    echo "0. Exit"
    echo "1. Quotes"
    echo "2. Previously read article"
    echo "3. A good read"
    echo "4. rss"
    echo "5. Do something!"
    echo "6. Vim tip"
}

# Function to handle user input
handle_input() {
    echo
    read -n 1 -p "Enter your choice: " choice
    echo
    echo
    case $choice in
        [0q])
            echo "Have a great day! Not every day is a productivity day!"
            exit 0
            ;;
        1)
            fortune ~/.config/fortune/lewis
            echo
            fortune
            verse
            ;;
        2)
            fetch_a_read_article
            ;;
        3)
            get_a_good_read
            ;;
        4)
            newsboat
            ;;
        5)
            get_a_todo
            echo
            ;;
        6)
            vim_tip
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac
}

# Main program loop
display_greeting
while true; do
    display_menu
    handle_input
done

