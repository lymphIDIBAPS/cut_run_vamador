import pyBigWig
pyBigWig.remote

bw = pyBigWig.open('/home/oscar/Descargas/CR3_29.bw')

bw.chroms()
bw.header()
bw.stats("chr1")
bw.IsBigWig()