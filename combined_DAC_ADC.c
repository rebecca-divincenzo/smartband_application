//Jessica Buchanan - 001235839 - 2DX4 Final Project

#include <stdint.h>
#include "tm4c1294ncpdt.h"
#include "vl53l1x_api.h"
#include "PLL.h"
#include "SysTick.h"
#include "onboardLEDs.h"
#include "uart.h"



//device in interrupt mode (GPIO1 pin signal)
#define isInterrupt 0 /* If isInterrupt = 1 then device working in interrupt mode, else device working in polling mode */


void PortL_Init(void){
	SYSCTL_RCGCGPIO_R |= SYSCTL_RCGCGPIO_R10;                 //activate the clock for Port L
	while((SYSCTL_PRGPIO_R&SYSCTL_PRGPIO_R10) == 0){};        //allow time for clock to stabilize 
	GPIO_PORTL_DIR_R |= 0b00011111;      			  						// make PL0 an output - output of serial clock to DAC and ADC
	GPIO_PORTL_DEN_R |= 0b00011111;													// make PL1-2 output for MODE for ADC
	return;																									// PL3 - output of master clock to ADC - need to figure out more
}
	
	
void PortM_Init(void){
	SYSCTL_RCGCGPIO_R |= SYSCTL_RCGCGPIO_R11;                 //activate the clock for Port M
	while((SYSCTL_PRGPIO_R&SYSCTL_PRGPIO_R11) == 0){};        //allow time for clock to stabilize 																														// make PM0-3 an input for digital intake from ADC, 
	GPIO_PORTM_DIR_R |= 0b00010000;       			  						// make PM0-3 input for 4 ADC channels
	GPIO_PORTM_DEN_R |= 0b00011111;														// PM4 is clock for ADC
	return;																										
}

void PortF_Init(void){
	SYSCTL_RCGCGPIO_R |= SYSCTL_RCGCGPIO_R5;                 //activate the clock for Port F
	while((SYSCTL_PRGPIO_R&SYSCTL_PRGPIO_R5) == 0){};        //allow time for clock to stabilize 
	GPIO_PORTF_DIR_R |= 0b00001110;       			  					// make PF1 an output - SYNC signal to ADC
	GPIO_PORTF_DEN_R |= 0b00001110;													// PF0 an output for SYNC signal to DAC
	return;																									// PF2-3 output for setting format for ADC - split PF2 to FORMAT0 and FORMAT2
																													
}

void PortE_Init(void){	
	SYSCTL_RCGCGPIO_R |= SYSCTL_RCGCGPIO_R4;		  						// activate the clock for Port E
	while((SYSCTL_PRGPIO_R&SYSCTL_PRGPIO_R4) == 0){};	  			// allow time for clock to stabilize
	GPIO_PORTE_DEN_R |= 0b00000111;
	GPIO_PORTE_DIR_R |= 0b00000111;                           // make PE0 output - output of the digital signal to DAC
																														// make PE1 output - output of PWDN for ADC - try to split to all 4 channels? 
	return;																										//PE2 output for settng CLKDIV to 1
}

void copyArray(uint8_t *tempArray, uint8_t *returnBitArray)
{
	for (int i = 0; i < 24; i++)
	{
		(tempArray)[i] = returnBitArray[i];
	}
}

void lookupOutputTest(int cycle, uint8_t *tempArray) {
	uint8_t returnBitArray5[24] = {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
		copyArray(tempArray, returnBitArray5);
}
void UART_Init(void);
void outputADCData(uint8_t *CH1, uint8_t *CH2, uint8_t *CH3, uint8_t *CH4)
{
	//UART for connection to computer to test ADC, will replace with Bluetooth communication
	int j=0;
	sprintf(printf_buffer,"CH1");
	UART_printf(printf_buffer);
	for(j=0; j<24; j++){
				sprintf(printf_buffer,"%u\n",CH1[j]);
				UART_printf(printf_buffer);
			}
	sprintf(printf_buffer,"CH2");
	UART_printf(printf_buffer);
	for(j=0; j<24; j++){
				sprintf(printf_buffer,"%u\n",CH2[j]);
				UART_printf(printf_buffer);
			}
	sprintf(printf_buffer,"CH3");
	UART_printf(printf_buffer);
	for(j=0; j<24; j++){
				sprintf(printf_buffer,"%u\n",CH3[j]);
				UART_printf(printf_buffer);
			}
	sprintf(printf_buffer,"CH4");
	UART_printf(printf_buffer);
	for(j=0; j<24; j++){
				sprintf(printf_buffer,"%u\n",CH4[j]);
				UART_printf(printf_buffer);
			}
	sprintf(printf_buffer,"+");
	UART_printf(printf_buffer);
	return;
}

void lookupOutput(int cycle, uint8_t *tempArray) {
	uint8_t returnBitArray0[24] = { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
	uint8_t returnBitArray1[24] = { 1,0,0,0,0,0,1,1,1,1,1,1,0,1,0,1,0,0,0,0,0,0,0,0 };
	uint8_t returnBitArray2[24] = { 1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0 };
	uint8_t returnBitArray3[24] = { 1,0,0,0,1,0,1,0,0,1,0,1,1,0,1,1,0,0,0,0,0,0,0,0 };
	uint8_t returnBitArray4[24] = { 1,0,0,0,1,1,0,0,0,0,1,0,1,1,0,0,0,0,0,0,0,0,0,0 };
	uint8_t returnBitArray5[24] = { 1,0,0,0,1,1,0,0,1,1,0,0,1,1,0,1,0,0,0,0,0,0,0,0 };

	uint8_t returnBitArray11[24] = { 0,1,1,1,1,1,0,0,0,0,0,0,1,0,1,1,0,0,0,0,0,0,0,0 };
	uint8_t returnBitArray12[24] = { 0,1,1,1,1,0,0,0,0,1,1,1,1,0,1,0,0,0,0,0,0,0,0,0 };
	uint8_t returnBitArray13[24] = { 0,1,1,1,0,1,0,1,1,0,1,0,0,1,0,1,0,0,0,0,0,0,0,0 };
	uint8_t returnBitArray14[24] = { 0,1,1,1,0,0,1,1,1,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0 };
	uint8_t returnBitArray15[24] = { 0,1,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,0,0,0,0,0,0 };
	switch (cycle)
	{
	case 0:
		copyArray(tempArray, returnBitArray0);
		break;
	case 1:
		copyArray(tempArray, returnBitArray1);
		break;
	case 2:
		copyArray(tempArray, returnBitArray2);
		break;
	case 3:
		copyArray(tempArray, returnBitArray3);
		break;
	case 4:
		copyArray(tempArray, returnBitArray4);
		break;
	case 5:
		copyArray(tempArray, returnBitArray5);
		break;
	case 6:
		copyArray(tempArray, returnBitArray4);
		break;
	case 7:
		copyArray(tempArray, returnBitArray3);
		break;
	case 8:
		copyArray(tempArray, returnBitArray2);
		break;
	case 9:
		copyArray(tempArray, returnBitArray1);
		break;
	case 10:
		copyArray(tempArray, returnBitArray0);
		break;
	case 11:
		copyArray(tempArray, returnBitArray11);
		break;
	case 12:
		copyArray(tempArray, returnBitArray12);
		break;
	case 13:
		copyArray(tempArray, returnBitArray13);
		break;
	case 14:
		copyArray(tempArray, returnBitArray14);
		break;
	case 15:
		copyArray(tempArray, returnBitArray15);
		break;
	case 16:
		copyArray(tempArray, returnBitArray14);
		break;
	case 17:
		copyArray(tempArray, returnBitArray13);
		break;
	case 18:
		copyArray(tempArray, returnBitArray12);
		break;
	case 19:
		copyArray(tempArray, returnBitArray11);
		break;
	default:
		copyArray(tempArray, returnBitArray0);
		break;
	}
}

int main(void) {
  uint8_t myBitArray[24];
	lookupOutput(0, myBitArray);
  uint8_t clockCounter = 0;
	uint8_t bitCounter = 25;
	uint8_t cycleCounter = 0;
	uint8_t ADCbitCounter = 0;
	//initialize
	uint8_t CH1[24];
	uint8_t CH2[24];
	uint8_t CH3[24];
	uint8_t CH4[24];
	//initialize
	PortL_Init(); // Digital output to DAC
	PortM_Init(); //Clock output to DAC
	PortF_Init(); // SYNC output to DAC
	PortE_Init();
	PLL_Init();	
	SysTick_Init();
	UART_Init();
	onboardLEDs_Init();
	GPIO_PORTF_DATA_R = 0b00001000; 
	GPIO_PORTL_DATA_R = 0b00000000; // Clock
	GPIO_PORTE_DATA_R = 0b00000110;
	GPIO_PORTM_DATA_R = 0b00000000;
		

	while(1){
		if(ADCbitCounter<1) //Set FSYNC high to mark beginning of frame to ADC
		{
			GPIO_PORTF_DATA_R |= 1 << 1;
		}
		else{
			GPIO_PORTF_DATA_R |= 0 << 1;
		}
		if(bitCounter<1 || bitCounter > 24) // Set ADC SYNC to high for last and first "bit" - SYNC waiting time
		{
			GPIO_PORTF_DATA_R |= 1 << 0; // SYNC high between data writes
		}
		else{
			GPIO_PORTF_DATA_R |= 0 << 0; // DAC SYNC active low when writing data
			if(myBitArray[bitCounter-1] ==0)
			{
				GPIO_PORTE_DATA_R |= 0 << 0;
			}
			else{
				GPIO_PORTE_DATA_R |= 1 << 0;
			}
		}
		GPIO_PORTL_DATA_R |= 0 << 0;
		SysTick_Wait(13); //Wait 13 clock cycles before flipping DAC clock high
		GPIO_PORTL_DATA_R |= 1 << 0;
		SysTick_Wait(13); //Wait 13 clock cycles before flipping DAC low. 
		GPIO_PORTM_DATA_R ^= 0b00010000; //Flip ADC Clock every 26 clock cycles
		bitCounter--;
		if(bitCounter >100){ //100 because it is in bits so 0 goes to 255 when decremented
			cycleCounter++;
			bitCounter = 25;
			if(cycleCounter > 19)
				{
					cycleCounter = 0;
				}
				lookupOutputTest(cycleCounter, myBitArray);
		}
		if((GPIO_PORTM_DATA_R& (1<<4))){
			CH1[ADCbitCounter] = GPIO_PORTM_DATA_R & 0b00000001;
			CH2[ADCbitCounter] = GPIO_PORTM_DATA_R & 0b00000010;
			CH3[ADCbitCounter] = GPIO_PORTM_DATA_R & 0b00000100;
			CH4[ADCbitCounter] = GPIO_PORTM_DATA_R & 0b00001000;
			ADCbitCounter++;
			if(ADCbitCounter > 23)
				{
					outputADCData(CH1, CH2, CH3, CH4); //when 24 bits have been read in, send the data out via Bluetooth chip
					ADCbitCounter =0;
				}
		}
	}
}


