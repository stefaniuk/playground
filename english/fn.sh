function split_part() {
    echo $(echo $1 | awk '{ split($1,a,v1); print a[v2]; }' v1=$2 v2=$3)
}
function get_links() {
    number=10
    links="/oxford3000/ox3k_A-B/,/oxford3000/ox3k_C-D/,/oxford3000/ox3k_E-G/,/oxford3000/ox3k_H-K/,/oxford3000/ox3k_L-N/,/oxford3000/ox3k_O-P/,/oxford3000/ox3k_Q-R/,/oxford3000/ox3k_S/,/oxford3000/ox3k_T/,/oxford3000/ox3k_U-Z/"
    pages="5,6,5,3,4,4,3,4,2,3"
    for i in $(seq 1 $number); do
        link=$(split_part $links ',' $i)
        n=$(split_part $pages ',' $i)
        for page in $(seq 1 $n); do
            wget -qO- http://oald8.oxfordlearnersdictionaries.com${link}?page=${page} | sed s/onclick/'\n'onclick/g | sed -rn 's/.*onclick="([^"]*)".*/\1/p' | sed -rn "s/playSoundFromFlash\('(.*)', ''\);return false;/\1/p" | grep uk_pron
        done
    done
}
get_links | sort | uniq > ~/links.txt
mkdir ~/uk_words
links=$(cat ~/links.txt)
for link in $links; do
    wget http://oald8.oxfordlearnersdictionaries.com${link} -P ~/uk_words
done
