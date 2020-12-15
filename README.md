# miner
Dockerized Crypto Miners

-----

- Select the crypto miner implementation:
  ```
  MINER={cpuminer-multi | cpuminer-opt | cpuminer-rkz | cpuminer-opt-sugarchain | cpuminer-opt-cpupower | cpuminer-opt-neoscrypt }
  ```
- Set the architecture of the host:
  ```
  ARCH="`gcc -march=native -Q --help=target | awk '$1 == "-march=" {print $2}'`"
  ```
- Run the crypto miner that has been compiled for your host architecture:
  ```
  docker-compose up -d "innovanon/$MINER:$ARCH"
  ```

