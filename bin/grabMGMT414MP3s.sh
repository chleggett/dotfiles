
#!/bin/bash
# nested-loop.sh: Nested "for" loops.

# Beginning of outer loop.
for number in {1..10}
do
    # ===============================================
      # Beginning of inner loop.
        for letter in {A..F}
          do
            echo
            echo ++++++++++++++++++++++
            echo
            echo https://www.sans.org/tmppdf/6df4b0647ab4587768f625b002a2c208/MGT414_DOM"$number$letter"_20120410.mp3
            wget https://www.sans.org/tmppdf/6df4b0647ab4587768f625b002a2c208/MGT414_DOM"$number$letter"_20120410.mp3
          done
      # End of inner loop.
    # ===============================================

done
# End of outer loop.

exit 0
