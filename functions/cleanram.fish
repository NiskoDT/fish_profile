function cleanram --description "MemReduct equivalent - clean RAM cache"
    sync
    sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches; echo 1 > /proc/sys/vm/compact_memory'
    echo "RAM cleaned - Available: "(free -h | awk '/Mem:/ {print $7}')
end
