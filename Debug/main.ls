   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.11.14 - 18 Nov 2019
   3                     ; Generator (Limited) V4.4.11 - 19 Nov 2019
  14                     	bsct
  15  0000               _addr:
  16  0000 00            	dc.b	0
  17  0001               _data:
  18  0001 0000          	dc.w	0
  58                     ; 44 main()
  58                     ; 45 {
  60                     	switch	.text
  61  0000               _main:
  65                     ; 46 	clk_init();
  67  0000 cd00cd        	call	_clk_init
  69                     ; 47 	gpio_init();
  71  0003 cd009f        	call	_gpio_init
  73                     ; 48 	spi_init();
  75  0006 cd012f        	call	_spi_init
  77  0009               L12:
  78                     ; 51 	addr=0;
  80  0009 3f00          	clr	_addr
  81                     ; 52 	data=0;
  83  000b 5f            	clrw	x
  84  000c bf01          	ldw	_data,x
  85                     ; 53 	SPI_BiDirectionalLineConfig (SPI_DIRECTION_TX);
  87  000e a601          	ld	a,#1
  88  0010 cd0000        	call	_SPI_BiDirectionalLineConfig
  90                     ; 54 	NRF2_RR(addr);
  92  0013 b600          	ld	a,_addr
  93  0015 cd0381        	call	_NRF2_RR
  95                     ; 57 	if (SPI_GetFlagStatus(SPI_FLAG_RXNE)){
  97  0018 a601          	ld	a,#1
  98  001a cd0000        	call	_SPI_GetFlagStatus
 100  001d 4d            	tnz	a
 101  001e 272a          	jreq	L14
 102                     ; 58 			data=SPI_ReceiveData();
 104  0020 cd0000        	call	_SPI_ReceiveData
 106  0023 5f            	clrw	x
 107  0024 97            	ld	xl,a
 108  0025 bf01          	ldw	_data,x
 109                     ; 59 			blink(5,50);
 111  0027 ae0032        	ldw	x,#50
 112  002a 89            	pushw	x
 113  002b ae0005        	ldw	x,#5
 114  002e cd0200        	call	_blink
 116  0031 85            	popw	x
 118  0032               L13:
 119                     ; 60 			while(SPI_GetFlagStatus(SPI_FLAG_BSY )){};
 121  0032 a680          	ld	a,#128
 122  0034 cd0000        	call	_SPI_GetFlagStatus
 124  0037 4d            	tnz	a
 125  0038 26f8          	jrne	L13
 127  003a               L53:
 128                     ; 68 	if (data==8||data==247){
 131  003a be01          	ldw	x,_data
 132  003c a30008        	cpw	x,#8
 133  003f 272d          	jreq	L55
 135  0041 be01          	ldw	x,_data
 136  0043 a300f7        	cpw	x,#247
 137  0046 2639          	jrne	L35
 138  0048 2024          	jra	L55
 139  004a               L14:
 140                     ; 62 			while(SPI_GetFlagStatus(SPI_FLAG_BSY )){};
 142  004a a680          	ld	a,#128
 143  004c cd0000        	call	_SPI_GetFlagStatus
 145  004f 4d            	tnz	a
 146  0050 26f8          	jrne	L14
 147                     ; 63 			data=SPI_ReceiveData();
 150  0052 cd0000        	call	_SPI_ReceiveData
 152  0055 5f            	clrw	x
 153  0056 97            	ld	xl,a
 154  0057 bf01          	ldw	_data,x
 155                     ; 64 			blink(5,50);
 157  0059 ae0032        	ldw	x,#50
 158  005c 89            	pushw	x
 159  005d ae0005        	ldw	x,#5
 160  0060 cd0200        	call	_blink
 162  0063 85            	popw	x
 164  0064               L74:
 165                     ; 65 			while(SPI_GetFlagStatus(SPI_FLAG_BSY )){};
 167  0064 a680          	ld	a,#128
 168  0066 cd0000        	call	_SPI_GetFlagStatus
 170  0069 4d            	tnz	a
 171  006a 26f8          	jrne	L74
 173  006c 20cc          	jra	L53
 174  006e               L55:
 175                     ; 69 		blink(3,1000);
 177  006e ae03e8        	ldw	x,#1000
 178  0071 89            	pushw	x
 179  0072 ae0003        	ldw	x,#3
 180  0075 cd0200        	call	_blink
 182  0078 85            	popw	x
 184  0079               L75:
 185                     ; 81 	delay_ms(3000);
 187  0079 ae0bb8        	ldw	x,#3000
 188  007c cd01dd        	call	_delay_ms
 191  007f 2088          	jra	L12
 192  0081               L35:
 193                     ; 71 	if (data==0){
 195  0081 be01          	ldw	x,_data
 196  0083 260d          	jrne	L16
 197                     ; 72 		blink(3,200);
 199  0085 ae00c8        	ldw	x,#200
 200  0088 89            	pushw	x
 201  0089 ae0003        	ldw	x,#3
 202  008c cd0200        	call	_blink
 204  008f 85            	popw	x
 206  0090 20e7          	jra	L75
 207  0092               L16:
 208                     ; 74 		blink(2,500);
 210  0092 ae01f4        	ldw	x,#500
 211  0095 89            	pushw	x
 212  0096 ae0002        	ldw	x,#2
 213  0099 cd0200        	call	_blink
 215  009c 85            	popw	x
 216  009d 20da          	jra	L75
 241                     ; 86 void gpio_init(void){
 242                     	switch	.text
 243  009f               _gpio_init:
 247                     ; 87 	GPIO_DeInit(MISO_port);
 249  009f ae500a        	ldw	x,#20490
 250  00a2 cd0000        	call	_GPIO_DeInit
 252                     ; 88 	GPIO_DeInit(LED_port);
 254  00a5 ae500f        	ldw	x,#20495
 255  00a8 cd0000        	call	_GPIO_DeInit
 257                     ; 89 	GPIO_Init(MOSI_port,((GPIO_Pin_TypeDef) MOSI_pin | MISO_pin | CLK_pin),GPIO_MODE_OUT_PP_LOW_FAST);
 259  00ab 4be0          	push	#224
 260  00ad 4be0          	push	#224
 261  00af ae500a        	ldw	x,#20490
 262  00b2 cd0000        	call	_GPIO_Init
 264  00b5 85            	popw	x
 265                     ; 90 	GPIO_Init(LED_port, ((GPIO_Pin_TypeDef) LED_pin | CE_pin) ,GPIO_MODE_OUT_PP_LOW_FAST); 
 267  00b6 4be0          	push	#224
 268  00b8 4b50          	push	#80
 269  00ba ae500f        	ldw	x,#20495
 270  00bd cd0000        	call	_GPIO_Init
 272  00c0 85            	popw	x
 273                     ; 91 	GPIO_Init(CSN_port, CSN_pin, GPIO_MODE_OUT_PP_HIGH_FAST);
 275  00c1 4bf0          	push	#240
 276  00c3 4b20          	push	#32
 277  00c5 ae500f        	ldw	x,#20495
 278  00c8 cd0000        	call	_GPIO_Init
 280  00cb 85            	popw	x
 281                     ; 92 }
 284  00cc 81            	ret
 317                     ; 94 void clk_init(void){
 318                     	switch	.text
 319  00cd               _clk_init:
 323                     ; 96 CLK_DeInit(); 				//Reset all clocks
 325  00cd cd0000        	call	_CLK_DeInit
 327                     ; 98 	CLK_HSECmd(DISABLE); //Choose desired clock
 329  00d0 4f            	clr	a
 330  00d1 cd0000        	call	_CLK_HSECmd
 332                     ; 99 	CLK_LSICmd(DISABLE); 
 334  00d4 4f            	clr	a
 335  00d5 cd0000        	call	_CLK_LSICmd
 337                     ; 100 	CLK_HSICmd(ENABLE); 
 339  00d8 a601          	ld	a,#1
 340  00da cd0000        	call	_CLK_HSICmd
 343  00dd               L701:
 344                     ; 103 	while(CLK_GetFlagStatus(CLK_FLAG_HSIRDY) == FALSE); 
 346  00dd ae0102        	ldw	x,#258
 347  00e0 cd0000        	call	_CLK_GetFlagStatus
 349  00e3 4d            	tnz	a
 350  00e4 27f7          	jreq	L701
 351                     ; 105 	CLK_ClockSwitchCmd(ENABLE); 		//Start clock execution
 353  00e6 a601          	ld	a,#1
 354  00e8 cd0000        	call	_CLK_ClockSwitchCmd
 356                     ; 107 	CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV8); 
 358  00eb a618          	ld	a,#24
 359  00ed cd0000        	call	_CLK_HSIPrescalerConfig
 361                     ; 109 	CLK_SYSCLKConfig(CLK_PRESCALER_CPUDIV1);
 363  00f0 a680          	ld	a,#128
 364  00f2 cd0000        	call	_CLK_SYSCLKConfig
 366                     ; 111 	CLK_ClockSwitchConfig(CLK_SWITCHMODE_AUTO, CLK_SOURCE_HSI, DISABLE, CLK_CURRENTCLOCKSTATE_ENABLE);
 368  00f5 4b01          	push	#1
 369  00f7 4b00          	push	#0
 370  00f9 ae01e1        	ldw	x,#481
 371  00fc cd0000        	call	_CLK_ClockSwitchConfig
 373  00ff 85            	popw	x
 374                     ; 115 CLK_PeripheralClockConfig(CLK_PERIPHERAL_I2C, DISABLE);
 376  0100 5f            	clrw	x
 377  0101 cd0000        	call	_CLK_PeripheralClockConfig
 379                     ; 116 CLK_PeripheralClockConfig(CLK_PERIPHERAL_SPI, ENABLE); 
 381  0104 ae0101        	ldw	x,#257
 382  0107 cd0000        	call	_CLK_PeripheralClockConfig
 384                     ; 117 CLK_PeripheralClockConfig(CLK_PERIPHERAL_UART1, DISABLE); 
 386  010a ae0300        	ldw	x,#768
 387  010d cd0000        	call	_CLK_PeripheralClockConfig
 389                     ; 118 CLK_PeripheralClockConfig(CLK_PERIPHERAL_AWU, DISABLE); 
 391  0110 ae1200        	ldw	x,#4608
 392  0113 cd0000        	call	_CLK_PeripheralClockConfig
 394                     ; 119 CLK_PeripheralClockConfig(CLK_PERIPHERAL_ADC, DISABLE); 
 396  0116 ae1300        	ldw	x,#4864
 397  0119 cd0000        	call	_CLK_PeripheralClockConfig
 399                     ; 120 CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER1, DISABLE);
 401  011c ae0700        	ldw	x,#1792
 402  011f cd0000        	call	_CLK_PeripheralClockConfig
 404                     ; 121 CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER2, ENABLE); 
 406  0122 ae0501        	ldw	x,#1281
 407  0125 cd0000        	call	_CLK_PeripheralClockConfig
 409                     ; 122 CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER4, ENABLE);
 411  0128 ae0401        	ldw	x,#1025
 412  012b cd0000        	call	_CLK_PeripheralClockConfig
 414                     ; 128 }
 417  012e 81            	ret
 443                     ; 130 void spi_init(void){
 444                     	switch	.text
 445  012f               _spi_init:
 449                     ; 132 	SPI_DeInit();
 451  012f cd0000        	call	_SPI_DeInit
 453                     ; 133 	SPI_Init(SPI_FIRSTBIT_MSB, 
 453                     ; 134 	SPI_BAUDRATEPRESCALER_8,
 453                     ; 135 	SPI_MODE_MASTER,
 453                     ; 136 	SPI_CLOCKPOLARITY_HIGH,
 453                     ; 137 	SPI_CLOCKPHASE_1EDGE,
 453                     ; 138 	SPI_DATADIRECTION_2LINES_FULLDUPLEX,
 453                     ; 139 	SPI_NSS_SOFT, 0x00); 
 455  0132 4b00          	push	#0
 456  0134 4b02          	push	#2
 457  0136 4b00          	push	#0
 458  0138 4b00          	push	#0
 459  013a 4b02          	push	#2
 460  013c 4b04          	push	#4
 461  013e ae0010        	ldw	x,#16
 462  0141 cd0000        	call	_SPI_Init
 464  0144 5b06          	addw	sp,#6
 465                     ; 140 	SPI_Cmd(ENABLE);
 467  0146 a601          	ld	a,#1
 468  0148 cd0000        	call	_SPI_Cmd
 470                     ; 141 }
 473  014b 81            	ret
 512                     ; 143 void delay_us(unsigned int us) {
 513                     	switch	.text
 514  014c               _delay_us:
 516  014c 89            	pushw	x
 517       00000000      OFST:	set	0
 520                     ; 146 TIM4_DeInit();
 522  014d cd0000        	call	_TIM4_DeInit
 524                     ; 148 	if((us <= 200) && (us >= 0)) {
 526  0150 1e01          	ldw	x,(OFST+1,sp)
 527  0152 a300c9        	cpw	x,#201
 528  0155 240d          	jruge	L141
 529                     ; 149 		TIM4_TimeBaseInit(TIM4_PRESCALER_16, 200); 
 531  0157 ae04c8        	ldw	x,#1224
 532  015a cd0000        	call	_TIM4_TimeBaseInit
 534                     ; 150 		TIM4_Cmd(ENABLE); 
 536  015d a601          	ld	a,#1
 537  015f cd0000        	call	_TIM4_Cmd
 540  0162 2065          	jra	L161
 541  0164               L141:
 542                     ; 151 	} else if((us <= 400) && (us > 200)) {
 544  0164 1e01          	ldw	x,(OFST+1,sp)
 545  0166 a30191        	cpw	x,#401
 546  0169 2418          	jruge	L541
 548  016b 1e01          	ldw	x,(OFST+1,sp)
 549  016d a300c9        	cpw	x,#201
 550  0170 2511          	jrult	L541
 551                     ; 152 		us >>= 1;
 553  0172 0401          	srl	(OFST+1,sp)
 554  0174 0602          	rrc	(OFST+2,sp)
 555                     ; 153 		TIM4_TimeBaseInit(TIM4_PRESCALER_32, 200); 
 557  0176 ae05c8        	ldw	x,#1480
 558  0179 cd0000        	call	_TIM4_TimeBaseInit
 560                     ; 154 		TIM4_Cmd(ENABLE); 
 562  017c a601          	ld	a,#1
 563  017e cd0000        	call	_TIM4_Cmd
 566  0181 2046          	jra	L161
 567  0183               L541:
 568                     ; 155 	} else if((us <= 800) && (us > 400)) {
 570  0183 1e01          	ldw	x,(OFST+1,sp)
 571  0185 a30321        	cpw	x,#801
 572  0188 241d          	jruge	L151
 574  018a 1e01          	ldw	x,(OFST+1,sp)
 575  018c a30191        	cpw	x,#401
 576  018f 2516          	jrult	L151
 577                     ; 156 		us >>= 2; 
 579  0191 a602          	ld	a,#2
 580  0193               L61:
 581  0193 0401          	srl	(OFST+1,sp)
 582  0195 0602          	rrc	(OFST+2,sp)
 583  0197 4a            	dec	a
 584  0198 26f9          	jrne	L61
 585                     ; 157 		TIM4_TimeBaseInit(TIM4_PRESCALER_64, 200);
 587  019a ae06c8        	ldw	x,#1736
 588  019d cd0000        	call	_TIM4_TimeBaseInit
 590                     ; 158 		TIM4_Cmd(ENABLE);
 592  01a0 a601          	ld	a,#1
 593  01a2 cd0000        	call	_TIM4_Cmd
 596  01a5 2022          	jra	L161
 597  01a7               L151:
 598                     ; 159 	} else if((us <= 1600) && (us > 800)) {
 600  01a7 1e01          	ldw	x,(OFST+1,sp)
 601  01a9 a30641        	cpw	x,#1601
 602  01ac 241b          	jruge	L161
 604  01ae 1e01          	ldw	x,(OFST+1,sp)
 605  01b0 a30321        	cpw	x,#801
 606  01b3 2514          	jrult	L161
 607                     ; 160 		us >>= 3; 
 609  01b5 a603          	ld	a,#3
 610  01b7               L02:
 611  01b7 0401          	srl	(OFST+1,sp)
 612  01b9 0602          	rrc	(OFST+2,sp)
 613  01bb 4a            	dec	a
 614  01bc 26f9          	jrne	L02
 615                     ; 161 		TIM4_TimeBaseInit(TIM4_PRESCALER_128, 200); 
 617  01be ae07c8        	ldw	x,#1992
 618  01c1 cd0000        	call	_TIM4_TimeBaseInit
 620                     ; 162 		TIM4_Cmd(ENABLE); 
 622  01c4 a601          	ld	a,#1
 623  01c6 cd0000        	call	_TIM4_Cmd
 625  01c9               L161:
 626                     ; 165 	while(TIM4_GetCounter() < us); 
 628  01c9 cd0000        	call	_TIM4_GetCounter
 630  01cc 5f            	clrw	x
 631  01cd 97            	ld	xl,a
 632  01ce 1301          	cpw	x,(OFST+1,sp)
 633  01d0 25f7          	jrult	L161
 634                     ; 166 	TIM4_ClearFlag(TIM4_FLAG_UPDATE); 
 636  01d2 a601          	ld	a,#1
 637  01d4 cd0000        	call	_TIM4_ClearFlag
 639                     ; 167 	TIM4_Cmd(DISABLE); 
 641  01d7 4f            	clr	a
 642  01d8 cd0000        	call	_TIM4_Cmd
 644                     ; 168 }	
 647  01db 85            	popw	x
 648  01dc 81            	ret
 683                     ; 170 void delay_ms(unsigned int ms) {
 684                     	switch	.text
 685  01dd               _delay_ms:
 687  01dd 89            	pushw	x
 688       00000000      OFST:	set	0
 691                     ; 171 	ms=ms*8;		// correction factor to compensate TIM4 dividers scale mismatch
 693  01de a603          	ld	a,#3
 694  01e0               L42:
 695  01e0 0802          	sll	(OFST+2,sp)
 696  01e2 0901          	rlc	(OFST+1,sp)
 697  01e4 4a            	dec	a
 698  01e5 26f9          	jrne	L42
 700  01e7 2006          	jra	L502
 701  01e9               L302:
 702                     ; 173 	delay_us(1000);
 704  01e9 ae03e8        	ldw	x,#1000
 705  01ec cd014c        	call	_delay_us
 707  01ef               L502:
 708                     ; 172 	while(ms--) { 
 710  01ef 1e01          	ldw	x,(OFST+1,sp)
 711  01f1 1d0001        	subw	x,#1
 712  01f4 1f01          	ldw	(OFST+1,sp),x
 713  01f6 1c0001        	addw	x,#1
 714  01f9 a30000        	cpw	x,#0
 715  01fc 26eb          	jrne	L302
 716                     ; 175 }
 719  01fe 85            	popw	x
 720  01ff 81            	ret
 774                     ; 177 void blink(int blink_num, unsigned int blink_time){
 775                     	switch	.text
 776  0200               _blink:
 778  0200 89            	pushw	x
 779  0201 89            	pushw	x
 780       00000002      OFST:	set	2
 783                     ; 178 	int k=0;
 785                     ; 179 		for(k=0;k<blink_num;k++){
 787  0202 5f            	clrw	x
 788  0203 1f01          	ldw	(OFST-1,sp),x
 791  0205 2021          	jra	L342
 792  0207               L732:
 793                     ; 180 			GPIO_WriteReverse(LED_port,LED_pin);
 795  0207 4b40          	push	#64
 796  0209 ae500f        	ldw	x,#20495
 797  020c cd0000        	call	_GPIO_WriteReverse
 799  020f 84            	pop	a
 800                     ; 181 			delay_ms(blink_time);
 802  0210 1e07          	ldw	x,(OFST+5,sp)
 803  0212 adc9          	call	_delay_ms
 805                     ; 182 			GPIO_WriteReverse(LED_port,LED_pin);
 807  0214 4b40          	push	#64
 808  0216 ae500f        	ldw	x,#20495
 809  0219 cd0000        	call	_GPIO_WriteReverse
 811  021c 84            	pop	a
 812                     ; 183 			delay_ms(blink_time);
 814  021d 1e07          	ldw	x,(OFST+5,sp)
 815  021f adbc          	call	_delay_ms
 817                     ; 179 		for(k=0;k<blink_num;k++){
 819  0221 1e01          	ldw	x,(OFST-1,sp)
 820  0223 1c0001        	addw	x,#1
 821  0226 1f01          	ldw	(OFST-1,sp),x
 823  0228               L342:
 826  0228 9c            	rvf
 827  0229 1e01          	ldw	x,(OFST-1,sp)
 828  022b 1303          	cpw	x,(OFST+1,sp)
 829  022d 2fd8          	jrslt	L732
 830                     ; 186 }
 834  022f 5b04          	addw	sp,#4
 835  0231 81            	ret
 896                     ; 188 int pow(int base, int power){
 897                     	switch	.text
 898  0232               _pow:
 900  0232 89            	pushw	x
 901  0233 5204          	subw	sp,#4
 902       00000004      OFST:	set	4
 905                     ; 189 	int res=1;
 907  0235 ae0001        	ldw	x,#1
 908  0238 1f01          	ldw	(OFST-3,sp),x
 910                     ; 190 	int i=0;
 912                     ; 191 	for(i=0; i<power; i++){
 914  023a 5f            	clrw	x
 915  023b 1f03          	ldw	(OFST-1,sp),x
 918  023d 2010          	jra	L503
 919  023f               L103:
 920                     ; 192 	res=res*base;
 922  023f 1e01          	ldw	x,(OFST-3,sp)
 923  0241 1605          	ldw	y,(OFST+1,sp)
 924  0243 cd0000        	call	c_imul
 926  0246 1f01          	ldw	(OFST-3,sp),x
 928                     ; 191 	for(i=0; i<power; i++){
 930  0248 1e03          	ldw	x,(OFST-1,sp)
 931  024a 1c0001        	addw	x,#1
 932  024d 1f03          	ldw	(OFST-1,sp),x
 934  024f               L503:
 937  024f 9c            	rvf
 938  0250 1e03          	ldw	x,(OFST-1,sp)
 939  0252 1309          	cpw	x,(OFST+5,sp)
 940  0254 2fe9          	jrslt	L103
 941                     ; 194 	return res;
 944  0256 1e01          	ldw	x,(OFST-3,sp)
 947  0258 5b06          	addw	sp,#6
 948  025a 81            	ret
1010                     .const:	section	.text
1011  0000               L43:
1012  0000 0000000a      	dc.l	10
1013                     ; 197 int bin2dec(long n) {
1014                     	switch	.text
1015  025b               _bin2dec:
1017  025b 5206          	subw	sp,#6
1018       00000006      OFST:	set	6
1021                     ; 198     int dec = 0;
1023  025d 5f            	clrw	x
1024  025e 1f01          	ldw	(OFST-5,sp),x
1026                     ; 199 		int i = 0;
1028  0260 5f            	clrw	x
1029  0261 1f03          	ldw	(OFST-3,sp),x
1031                     ; 200 		int rem=0;
1034  0263 2040          	jra	L543
1035  0265               L343:
1036                     ; 202         rem = n % 10;
1038  0265 96            	ldw	x,sp
1039  0266 1c0009        	addw	x,#OFST+3
1040  0269 cd0000        	call	c_ltor
1042  026c ae0000        	ldw	x,#L43
1043  026f cd0000        	call	c_lmod
1045  0272 be02          	ldw	x,c_lreg+2
1046  0274 1f05          	ldw	(OFST-1,sp),x
1048                     ; 203         n /= 10;
1050  0276 96            	ldw	x,sp
1051  0277 1c0009        	addw	x,#OFST+3
1052  027a cd0000        	call	c_ltor
1054  027d ae0000        	ldw	x,#L43
1055  0280 cd0000        	call	c_ldiv
1057  0283 96            	ldw	x,sp
1058  0284 1c0009        	addw	x,#OFST+3
1059  0287 cd0000        	call	c_rtol
1061                     ; 204         dec += rem * pow(2, i);
1063  028a 1e03          	ldw	x,(OFST-3,sp)
1064  028c 89            	pushw	x
1065  028d ae0002        	ldw	x,#2
1066  0290 ada0          	call	_pow
1068  0292 5b02          	addw	sp,#2
1069  0294 1605          	ldw	y,(OFST-1,sp)
1070  0296 cd0000        	call	c_imul
1072  0299 72fb01        	addw	x,(OFST-5,sp)
1073  029c 1f01          	ldw	(OFST-5,sp),x
1075                     ; 205         ++i;
1077  029e 1e03          	ldw	x,(OFST-3,sp)
1078  02a0 1c0001        	addw	x,#1
1079  02a3 1f03          	ldw	(OFST-3,sp),x
1081  02a5               L543:
1082                     ; 201     while (n != 0) {
1084  02a5 96            	ldw	x,sp
1085  02a6 1c0009        	addw	x,#OFST+3
1086  02a9 cd0000        	call	c_lzmp
1088  02ac 26b7          	jrne	L343
1089                     ; 207     return dec;
1091  02ae 1e01          	ldw	x,(OFST-5,sp)
1094  02b0 5b06          	addw	sp,#6
1095  02b2 81            	ret
1165                     ; 210 long dec2bin(int n) {
1166                     	switch	.text
1167  02b3               _dec2bin:
1169  02b3 89            	pushw	x
1170  02b4 520a          	subw	sp,#10
1171       0000000a      OFST:	set	10
1174                     ; 211     long  bin = 0;
1176  02b6 ae0000        	ldw	x,#0
1177  02b9 1f05          	ldw	(OFST-5,sp),x
1178  02bb ae0000        	ldw	x,#0
1179  02be 1f03          	ldw	(OFST-7,sp),x
1181                     ; 212     int rem, i = 1, step = 1;
1183  02c0 ae0001        	ldw	x,#1
1184  02c3 1f09          	ldw	(OFST-1,sp),x
1189  02c5 202c          	jra	L114
1190  02c7               L704:
1191                     ; 214         rem = n % 2;
1193  02c7 1e0b          	ldw	x,(OFST+1,sp)
1194  02c9 a602          	ld	a,#2
1195  02cb cd0000        	call	c_smodx
1197  02ce 1f07          	ldw	(OFST-3,sp),x
1199                     ; 215         n /= 2;
1201  02d0 1e0b          	ldw	x,(OFST+1,sp)
1202  02d2 a602          	ld	a,#2
1203  02d4 cd0000        	call	c_sdivx
1205  02d7 1f0b          	ldw	(OFST+1,sp),x
1206                     ; 216         bin += rem * i;
1208  02d9 1e07          	ldw	x,(OFST-3,sp)
1209  02db 1609          	ldw	y,(OFST-1,sp)
1210  02dd cd0000        	call	c_imul
1212  02e0 cd0000        	call	c_itolx
1214  02e3 96            	ldw	x,sp
1215  02e4 1c0003        	addw	x,#OFST-7
1216  02e7 cd0000        	call	c_lgadd
1219                     ; 217         i *= 10;
1221  02ea 1e09          	ldw	x,(OFST-1,sp)
1222  02ec a60a          	ld	a,#10
1223  02ee cd0000        	call	c_bmulx
1225  02f1 1f09          	ldw	(OFST-1,sp),x
1227  02f3               L114:
1228                     ; 213     while (n != 0) {
1230  02f3 1e0b          	ldw	x,(OFST+1,sp)
1231  02f5 26d0          	jrne	L704
1232                     ; 219     return bin;
1234  02f7 96            	ldw	x,sp
1235  02f8 1c0003        	addw	x,#OFST-7
1236  02fb cd0000        	call	c_ltor
1240  02fe 5b0c          	addw	sp,#12
1241  0300 81            	ret
1295                     ; 222 void spi_SendMsg(unsigned int data, int size){
1296                     	switch	.text
1297  0301               _spi_SendMsg:
1299  0301 89            	pushw	x
1300  0302 89            	pushw	x
1301       00000002      OFST:	set	2
1304                     ; 223 	int k=0;
1306                     ; 228 	for(k=0 ; k<size ; k++){	
1308  0303 5f            	clrw	x
1309  0304 1f01          	ldw	(OFST-1,sp),x
1312  0306 2035          	jra	L744
1313  0308               L344:
1314                     ; 229 		if (SPI_GetFlagStatus(SPI_FLAG_TXE)){
1316  0308 a602          	ld	a,#2
1317  030a cd0000        	call	_SPI_GetFlagStatus
1319  030d 4d            	tnz	a
1320  030e 2716          	jreq	L764
1321                     ; 230 			SPI_SendData (data);
1323  0310 7b04          	ld	a,(OFST+2,sp)
1324  0312 cd0000        	call	_SPI_SendData
1327  0315               L754:
1328                     ; 231 			while(SPI_GetFlagStatus(SPI_FLAG_BSY )){};
1330  0315 a680          	ld	a,#128
1331  0317 cd0000        	call	_SPI_GetFlagStatus
1333  031a 4d            	tnz	a
1334  031b 26f8          	jrne	L754
1336  031d               L364:
1337                     ; 228 	for(k=0 ; k<size ; k++){	
1340  031d 1e01          	ldw	x,(OFST-1,sp)
1341  031f 1c0001        	addw	x,#1
1342  0322 1f01          	ldw	(OFST-1,sp),x
1344  0324 2017          	jra	L744
1345  0326               L764:
1346                     ; 233 			while(SPI_GetFlagStatus(SPI_FLAG_BSY )){};
1348  0326 a680          	ld	a,#128
1349  0328 cd0000        	call	_SPI_GetFlagStatus
1351  032b 4d            	tnz	a
1352  032c 26f8          	jrne	L764
1353                     ; 234 			SPI_SendData (data);
1356  032e 7b04          	ld	a,(OFST+2,sp)
1357  0330 cd0000        	call	_SPI_SendData
1360  0333               L574:
1361                     ; 235 			while(SPI_GetFlagStatus(SPI_FLAG_BSY )){};
1363  0333 a680          	ld	a,#128
1364  0335 cd0000        	call	_SPI_GetFlagStatus
1366  0338 4d            	tnz	a
1367  0339 26f8          	jrne	L574
1369  033b 20e0          	jra	L364
1370  033d               L744:
1371                     ; 228 	for(k=0 ; k<size ; k++){	
1373  033d 9c            	rvf
1374  033e 1e01          	ldw	x,(OFST-1,sp)
1375  0340 1307          	cpw	x,(OFST+5,sp)
1376  0342 2fc4          	jrslt	L344
1377                     ; 240 }
1381  0344 5b04          	addw	sp,#4
1382  0346 81            	ret
1419                     ; 242 int spi_getmsg(){
1420                     	switch	.text
1421  0347               _spi_getmsg:
1423  0347 89            	pushw	x
1424       00000002      OFST:	set	2
1427                     ; 243 	int data=0;
1429                     ; 244 	SPI_BiDirectionalLineConfig (SPI_DIRECTION_RX);
1431  0348 4f            	clr	a
1432  0349 cd0000        	call	_SPI_BiDirectionalLineConfig
1434                     ; 245 	if (SPI_GetFlagStatus(SPI_FLAG_RXNE)){
1436  034c a601          	ld	a,#1
1437  034e cd0000        	call	_SPI_GetFlagStatus
1439  0351 4d            	tnz	a
1440  0352 2714          	jreq	L535
1441                     ; 246 			data=SPI_ReceiveData();
1443  0354 cd0000        	call	_SPI_ReceiveData
1445  0357 5f            	clrw	x
1446  0358 97            	ld	xl,a
1447  0359 1f01          	ldw	(OFST-1,sp),x
1450  035b               L525:
1451                     ; 247 			while(SPI_GetFlagStatus(SPI_FLAG_BSY )){};
1453  035b a680          	ld	a,#128
1454  035d cd0000        	call	_SPI_GetFlagStatus
1456  0360 4d            	tnz	a
1457  0361 26f8          	jrne	L525
1459  0363               L135:
1460                     ; 253 		return data;
1463  0363 1e01          	ldw	x,(OFST-1,sp)
1466  0365 5b02          	addw	sp,#2
1467  0367 81            	ret
1468  0368               L535:
1469                     ; 249 			while(SPI_GetFlagStatus(SPI_FLAG_BSY )){};
1471  0368 a680          	ld	a,#128
1472  036a cd0000        	call	_SPI_GetFlagStatus
1474  036d 4d            	tnz	a
1475  036e 26f8          	jrne	L535
1476                     ; 250 			data=SPI_ReceiveData();
1479  0370 cd0000        	call	_SPI_ReceiveData
1481  0373 5f            	clrw	x
1482  0374 97            	ld	xl,a
1483  0375 1f01          	ldw	(OFST-1,sp),x
1486  0377               L545:
1487                     ; 251 			while(SPI_GetFlagStatus(SPI_FLAG_BSY )){};
1489  0377 a680          	ld	a,#128
1490  0379 cd0000        	call	_SPI_GetFlagStatus
1492  037c 4d            	tnz	a
1493  037d 26f8          	jrne	L545
1495  037f 20e2          	jra	L135
1543                     ; 256 int NRF2_RR(uint8_t addr){
1544                     	switch	.text
1545  0381               _NRF2_RR:
1547  0381 88            	push	a
1548  0382 89            	pushw	x
1549       00000002      OFST:	set	2
1552                     ; 257 	int rx=1;
1554  0383 ae0001        	ldw	x,#1
1555  0386 1f01          	ldw	(OFST-1,sp),x
1557                     ; 258 	GPIO_WriteLow(CSN_port,CSN_pin);	//PULL CSN LOW
1559  0388 4b20          	push	#32
1560  038a ae500f        	ldw	x,#20495
1561  038d cd0000        	call	_GPIO_WriteLow
1563  0390 84            	pop	a
1564                     ; 259 	GPIO_WriteHigh(LED_port,LED_pin);
1566  0391 4b40          	push	#64
1567  0393 ae500f        	ldw	x,#20495
1568  0396 cd0000        	call	_GPIO_WriteHigh
1570  0399 84            	pop	a
1571                     ; 260 	delay_us(50);
1573  039a ae0032        	ldw	x,#50
1574  039d cd014c        	call	_delay_us
1576                     ; 261 	spi_SendMsg(addr,1);
1578  03a0 ae0001        	ldw	x,#1
1579  03a3 89            	pushw	x
1580  03a4 7b05          	ld	a,(OFST+3,sp)
1581  03a6 5f            	clrw	x
1582  03a7 97            	ld	xl,a
1583  03a8 cd0301        	call	_spi_SendMsg
1585  03ab 85            	popw	x
1586                     ; 262 	delay_ms(1);
1588  03ac ae0001        	ldw	x,#1
1589  03af cd01dd        	call	_delay_ms
1591                     ; 263 	GPIO_WriteHigh(CSN_port,CSN_pin);	//PULL CSN LOW
1593  03b2 4b20          	push	#32
1594  03b4 ae500f        	ldw	x,#20495
1595  03b7 cd0000        	call	_GPIO_WriteHigh
1597  03ba 84            	pop	a
1598                     ; 264 	GPIO_WriteLow(LED_port,LED_pin);
1600  03bb 4b40          	push	#64
1601  03bd ae500f        	ldw	x,#20495
1602  03c0 cd0000        	call	_GPIO_WriteLow
1604  03c3 84            	pop	a
1605                     ; 266 	return rx ;
1607  03c4 1e01          	ldw	x,(OFST-1,sp)
1610  03c6 5b03          	addw	sp,#3
1611  03c8 81            	ret
1644                     	xdef	_main
1645                     	xdef	_NRF2_RR
1646                     	xdef	_spi_getmsg
1647                     	xdef	_spi_SendMsg
1648                     	xdef	_dec2bin
1649                     	xdef	_bin2dec
1650                     	xdef	_pow
1651                     	xdef	_blink
1652                     	xdef	_delay_ms
1653                     	xdef	_delay_us
1654                     	xdef	_spi_init
1655                     	xdef	_clk_init
1656                     	xdef	_gpio_init
1657                     	xdef	_data
1658                     	xdef	_addr
1659                     	xref	_TIM4_ClearFlag
1660                     	xref	_TIM4_GetCounter
1661                     	xref	_TIM4_Cmd
1662                     	xref	_TIM4_TimeBaseInit
1663                     	xref	_TIM4_DeInit
1664                     	xref	_SPI_GetFlagStatus
1665                     	xref	_SPI_BiDirectionalLineConfig
1666                     	xref	_SPI_ReceiveData
1667                     	xref	_SPI_SendData
1668                     	xref	_SPI_Cmd
1669                     	xref	_SPI_Init
1670                     	xref	_SPI_DeInit
1671                     	xref	_GPIO_WriteReverse
1672                     	xref	_GPIO_WriteLow
1673                     	xref	_GPIO_WriteHigh
1674                     	xref	_GPIO_Init
1675                     	xref	_GPIO_DeInit
1676                     	xref	_CLK_GetFlagStatus
1677                     	xref	_CLK_SYSCLKConfig
1678                     	xref	_CLK_HSIPrescalerConfig
1679                     	xref	_CLK_ClockSwitchConfig
1680                     	xref	_CLK_PeripheralClockConfig
1681                     	xref	_CLK_ClockSwitchCmd
1682                     	xref	_CLK_LSICmd
1683                     	xref	_CLK_HSICmd
1684                     	xref	_CLK_HSECmd
1685                     	xref	_CLK_DeInit
1686                     	xref.b	c_lreg
1687                     	xref.b	c_x
1706                     	xref	c_bmulx
1707                     	xref	c_lgadd
1708                     	xref	c_itolx
1709                     	xref	c_sdivx
1710                     	xref	c_smodx
1711                     	xref	c_lzmp
1712                     	xref	c_rtol
1713                     	xref	c_ldiv
1714                     	xref	c_lmod
1715                     	xref	c_ltor
1716                     	xref	c_imul
1717                     	end
