if [[ $1 == "run" ]] then
    odin run src/
else
    odin build src/ -out:VOLLEY
fi