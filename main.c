/* 						MASTER SPI TRANSMIT

Code for spi full duplex master

 */

#include "stm8s.h"
#include "stm8s_spi.h"
// DEFINE

#define MISO_port		GPIOC
#define MISO_pin		GPIO_PIN_7
#define MOSI_port		GPIOC
#define MOSI_pin		GPIO_PIN_6
#define CLK_port		GPIOC					
#define CLK_pin			GPIO_PIN_5
#define CE_port			GPIOD					
#define CE_pin			GPIO_PIN_4
#define CSN_port		GPIOD					
#define CSN_pin			GPIO_PIN_5
#define LED_port		GPIOD					
#define LED_pin			GPIO_PIN_6

// VARIABLES

uint8_t addr=0;
int data=0;

// FUNCTIONS

void gpio_init(void);
void clk_init(void);
void spi_init(void);
void delay_us(unsigned int);
void delay_ms(unsigned int);
void blink(int blink_um, unsigned int blink_time);
int pow(int base, int power);
int bin2dec(long n); 
long dec2bin(int n);
void spi_SendMsg(unsigned int data, int size);
int spi_getmsg();
int NRF2_RR(uint8_t addr);
int NRF2_WR(uint8_t addr);
main()
{
	clk_init();
	gpio_init();
	spi_init();
	
	while (1){
	addr=0;
	data=0;
	SPI_BiDirectionalLineConfig (SPI_DIRECTION_TX);
	NRF2_RR(addr);


	if (SPI_GetFlagStatus(SPI_FLAG_RXNE)){
			data=SPI_ReceiveData();
			blink(5,50);
			while(SPI_GetFlagStatus(SPI_FLAG_BSY )){};
		}else{
			while(SPI_GetFlagStatus(SPI_FLAG_BSY )){};
			data=SPI_ReceiveData();
			blink(5,50);
			while(SPI_GetFlagStatus(SPI_FLAG_BSY )){};
		};

	if (data==8||data==247){
		blink(3,1000);
	}
	
	
	delay_ms(2000);
	
	};
}

void gpio_init(void){
	GPIO_DeInit(MISO_port);
	GPIO_DeInit(LED_port);
	GPIO_Init(MOSI_port,((GPIO_Pin_TypeDef) MOSI_pin | MISO_pin | CLK_pin),GPIO_MODE_OUT_PP_LOW_FAST);
	GPIO_Init(LED_port, ((GPIO_Pin_TypeDef) LED_pin | CE_pin) ,GPIO_MODE_OUT_PP_LOW_FAST); 
	GPIO_Init(CSN_port, CSN_pin, GPIO_MODE_OUT_PP_HIGH_FAST);
}

void clk_init(void){
	
CLK_DeInit(); 				//Reset all clocks
	
	CLK_HSECmd(DISABLE); //Choose desired clock
	CLK_LSICmd(DISABLE); 
	CLK_HSICmd(ENABLE); 
	
	// Wait for system to get clock ready
	while(CLK_GetFlagStatus(CLK_FLAG_HSIRDY) == FALSE); 
	
	CLK_ClockSwitchCmd(ENABLE); 		//Start clock execution
	//Set prescaler to 2 (8MHz clk freq)
	CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV8); 
	//Set CPU divider to 2 (4MHz clk freq)
	CLK_SYSCLKConfig(CLK_PRESCALER_CPUDIV1);
	//Sets the clock switch to the HSI
	CLK_ClockSwitchConfig(CLK_SWITCHMODE_AUTO, CLK_SOURCE_HSI, DISABLE, CLK_CURRENTCLOCKSTATE_ENABLE);
	
	
	//Disable clock to all peripheral except for TIM1
CLK_PeripheralClockConfig(CLK_PERIPHERAL_I2C, DISABLE);
CLK_PeripheralClockConfig(CLK_PERIPHERAL_SPI, ENABLE); 
CLK_PeripheralClockConfig(CLK_PERIPHERAL_UART1, DISABLE); 
CLK_PeripheralClockConfig(CLK_PERIPHERAL_AWU, DISABLE); 
CLK_PeripheralClockConfig(CLK_PERIPHERAL_ADC, DISABLE); 
CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER1, DISABLE);
CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER2, ENABLE); 
CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER4, ENABLE);
	
	
	//CLK_CCOConfig(CLK_OUTPUT_CPU); // Configure CCO clock speed
	//CLK_CCOCmd(DISABLE); 					// Enable the clock output
	//while(CLK_GetFlagStatus(CLK_FLAG_CCORDY) == FALSE);
}

void spi_init(void){
	
	SPI_DeInit();
	SPI_Init(SPI_FIRSTBIT_MSB, 
	SPI_BAUDRATEPRESCALER_8,
	SPI_MODE_MASTER,
	SPI_CLOCKPOLARITY_HIGH,
	SPI_CLOCKPHASE_1EDGE,
	SPI_DATADIRECTION_2LINES_FULLDUPLEX,
	SPI_NSS_SOFT, 0x00); 
	SPI_Cmd(ENABLE);
}

void delay_us(unsigned int us) {

//unsigned int us;
TIM4_DeInit();

	if((us <= 200) && (us >= 0)) {
		TIM4_TimeBaseInit(TIM4_PRESCALER_16, 200); 
		TIM4_Cmd(ENABLE); 
	} else if((us <= 400) && (us > 200)) {
		us >>= 1;
		TIM4_TimeBaseInit(TIM4_PRESCALER_32, 200); 
		TIM4_Cmd(ENABLE); 
	} else if((us <= 800) && (us > 400)) {
		us >>= 2; 
		TIM4_TimeBaseInit(TIM4_PRESCALER_64, 200);
		TIM4_Cmd(ENABLE);
	} else if((us <= 1600) && (us > 800)) {
		us >>= 3; 
		TIM4_TimeBaseInit(TIM4_PRESCALER_128, 200); 
		TIM4_Cmd(ENABLE); 
	} 
	
	while(TIM4_GetCounter() < us); 
	TIM4_ClearFlag(TIM4_FLAG_UPDATE); 
	TIM4_Cmd(DISABLE); 
}	

void delay_ms(unsigned int ms) {
	ms=ms*8;		// correction factor to compensate TIM4 dividers scale mismatch
	while(ms--) { 
	delay_us(1000);
	} 
}

void blink(int blink_num, unsigned int blink_time){
	int k=0;
		for(k=0;k<blink_num;k++){
			GPIO_WriteReverse(LED_port,LED_pin);
			delay_ms(blink_time);
			GPIO_WriteReverse(LED_port,LED_pin);
			delay_ms(blink_time);
		
	};
}

int pow(int base, int power){
	int res=1;
	int i=0;
	for(i=0; i<power; i++){
	res=res*base;
	};
	return res;
}

int bin2dec(long n) {
    int dec = 0;
		int i = 0;
		int rem=0;
    while (n != 0) {
        rem = n % 10;
        n /= 10;
        dec += rem * pow(2, i);
        ++i;
    }
    return dec;
}

long dec2bin(int n) {
    long  bin = 0;
    int rem, i = 1, step = 1;
    while (n != 0) {
        rem = n % 2;
        n /= 2;
        bin += rem * i;
        i *= 10;
    }
    return bin;
}

void spi_SendMsg(unsigned int data, int size){
	int k=0;
	//GPIO_WriteLow(CSN_port,CSN_pin);	
	//GPIO_WriteHigh(LED_port,LED_pin);
	//delay_us(20);
	//TRANSMIT MSG
	for(k=0 ; k<size ; k++){	
		if (SPI_GetFlagStatus(SPI_FLAG_TXE)){
			SPI_SendData (data);
			while(SPI_GetFlagStatus(SPI_FLAG_BSY )){};
		}else{
			while(SPI_GetFlagStatus(SPI_FLAG_BSY )){};
			SPI_SendData (data);
			while(SPI_GetFlagStatus(SPI_FLAG_BSY )){};
		};
	};
	//GPIO_WriteHigh(CSN_port,CSN_pin);//PUL CSN HIGH
	//GPIO_WriteLow(LED_port,LED_pin);
}

int spi_getmsg(){
	int data=0;
	SPI_BiDirectionalLineConfig (SPI_DIRECTION_RX);
	if (SPI_GetFlagStatus(SPI_FLAG_RXNE)){
			data=SPI_ReceiveData();
			while(SPI_GetFlagStatus(SPI_FLAG_BSY )){};
		}else{
			while(SPI_GetFlagStatus(SPI_FLAG_BSY )){};
			data=SPI_ReceiveData();
			while(SPI_GetFlagStatus(SPI_FLAG_BSY )){};
		};
		return data;
}

int NRF2_RR(uint8_t addr){
	int rx=1;
	GPIO_WriteLow(CSN_port,CSN_pin);	//PULL CSN LOW
	GPIO_WriteHigh(LED_port,LED_pin);
	delay_us(50);
	spi_SendMsg(addr,1);
	delay_ms(1);
	GPIO_WriteHigh(CSN_port,CSN_pin);	//PULL CSN LOW
	GPIO_WriteLow(LED_port,LED_pin);
	//rx=spi_GetMsg();
	return rx ;
}

int NRF2_WR(uint8_t addr){
	int tx=bin2dec();
	GPIO_WriteLow(CSN_port,CSN_pin);	//PULL CSN LOW
	GPIO_WriteHigh(LED_port,LED_pin);
	delay_us(50);
	spi_SendMsg(addr,tx);
	delay_ms(1);
	GPIO_WriteHigh(CSN_port,CSN_pin);	//PULL CSN LOW
	GPIO_WriteLow(LED_port,LED_pin);
	//rx=spi_GetMsg();
	return rx ;
}


#ifdef USE_FULL_ASSERT

/**
  * @brief  Reports the name of the source file and the source line number
  *   where the assert_param error has occurred.
  * @param file: pointer to the source file name
  * @param line: assert_param error line source number
  * @retval None
  */
void assert_failed(uint8_t* file, uint32_t line)
{ 
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */

  /* Infinite loop */
  while (1)
  {
  }
}
#endif