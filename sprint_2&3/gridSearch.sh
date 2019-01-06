# lrs=(0.05 0.1 0.25 0.5 0.7 1.0)
# dims=(100 150 200 250 300)
# wss=(2 4 5 7 10 15 20) #dont really know what this is
# wordNgramss=(1 2 3 4 5)
# epochs=(1 5 10 20 25 30 50 100 200 300)
# negs=(1 5 10 20) #dont really know what this is 
# losses=("ns" "hs" "softmax")
# saveOutputs=(1)

lrs=(0.05 1.0)
dims=(100 300)
wss=(2 4 5 ) #dont really know what this is
wordNgramss=(1 2 3)
epochs=(1 10 100)
negs=(1 5) #dont really know what this is 
losses=("ns" "hs" "softmax")
saveOutputs=(1)

i=0
dataAddr='model' #something that contains "train.txt" and "validation.txt"
outRootAddr='results' #something to which you will save the models, their metrics, the parameters they were trained on
for lr in "${lrs[@]}"
do
  for dim in "${dims[@]}"
  do
    for ws in "${wss[@]}"
    do
      for wordNgrams in "${wordNgramss[@]}"
      do
        for epoch in "${epochs[@]}"
        do
          for neg in "${negs[@]}"
          do
            for loss in "${losses[@]}"
            do
              for saveOutput in "${saveOutputs[@]}"
              do
                let "i += 1"
                echo "At model parameter combo i = $i"
                outAddr="$outRootAddr/$i"
                echo "Saving the model stuff at $outAddr"
                if [ ! -d $outAddr ];
                then
                  mkdir $outAddr
                fi

                #save some notes about parameters
                pars="[lr: $lr\ndim: $dim\nws: $ws\nwordNgrams: $wordNgrams\nepoch: $epoch\nneg: $neg\nloss: $loss\nsaveOutput: $saveOutput\n]"
                parFile="parList.txt"
                echo $pars > "$outAddr/$parFile"

                #train model, save cerr, save cout
                fasttext supervised -input $dataAddr/train.txt -output  $outAddr/model -lr $lr -lrUpdateRate 100 -dim $dim -ws $ws -epoch $epoch -neg $neg -loss $loss -thread 12 -wordNgrams $wordNgrams #-saveOutput $saveOutput  1>>$outAddr/$i.cout 2>>$outAddr/$i.cerr

                 #also save a test output at various at K's
                fasttext test $outAddr/model.bin $dataAddr/validation.txt 1 > $outAddr/At1.test
                fasttext test $outAddr/model.bin $dataAddr/validation.txt 2 > $outAddr/At2.test
                fasttext test $outAddr/model.bin $dataAddr/validation.txt 3 > $outAddr/At3.test
                fasttext test $outAddr/model.bin $dataAddr/validation.txt 4 > $outAddr/At4.test
                fasttext test $outAddr/model.bin $dataAddr/validation.txt 5 > $outAddr/At5.test
                fasttext test $outAddr/model.bin $dataAddr/validation.txt 6 > $outAddr/At6.test
                fasttext test $outAddr/model.bin $dataAddr/validation.txt 7 > $outAddr/At7.test
                fasttext test $outAddr/model.bin $dataAddr/validation.txt 8 > $outAddr/At8.test
                fasttext test $outAddr/model.bin $dataAddr/validation.txt 9 > $outAddr/At9.test
                fasttext test $outAddr/model.bin $dataAddr/validation.txt 10 > $outAddr/At10.test

              done
            done
          done
        done
      done
    done
  done
done
