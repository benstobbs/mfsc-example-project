#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <generated/csr.h>
#include <irq.h>
#include <libbase/uart.h>

int main(void) {
#ifdef CONFIG_CPU_HAS_INTERRUPT
	irq_setmask(0);
	irq_setie(1);
#endif
	uart_init();

	printf("Hello World!");

	while(1){
		int data = audiothrough_0_data_out_read();
		printf("Data: %d \n", data);
	}

	return 0;
}
