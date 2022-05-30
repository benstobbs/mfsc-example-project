#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <generated/csr.h>
#include <irq.h>
#include <libbase/uart.h>
#include <math.h>

void sendToHardware(double value, void (write_value)(uint32_t), void (write_sign)(uint32_t)){
	int is_neg = value < 0;

	double pos_value = value;
	if (is_neg){
		pos_value *= -1;
	}

	int int_val = (int) (pos_value * 1024);
	write_value(int_val);
	printf("%d \t %d\n", int_val, is_neg);
	write_sign(is_neg);
}

int main(void) {
#ifdef CONFIG_CPU_HAS_INTERRUPT
	irq_setmask(0);
	irq_setie(1);
#endif
	uart_init();

	printf("Hello World!\n");

	double f_samp = 68181;
	double db_gain = -18;
	double f0 = 5000;
	double Q = 5;

	double gain = pow(10, db_gain / 40);
	double omega_0 = 2 * 3.141 * (f0 / f_samp);
	double alpha = sin(omega_0) / (2 * Q);

	double alpha_times_a = alpha * gain;
	double alpha_over_a = alpha / gain;
	double min_two_cos_omega = -2 * cos(omega_0);

	double b0 = 1 + alpha_times_a;
	double b1 = min_two_cos_omega;
	double b2 = 1 - alpha_times_a;

	double a0 = 1 + alpha_over_a;
	double a1 = min_two_cos_omega;
	double a2 = 1 - alpha_over_a;

	sendToHardware(
		b0 / a0,
		audiothrough_0_x0_write,
		audiothrough_0_x0_neg_write
	);

	sendToHardware(
		b1 / a0,
		audiothrough_0_x1_write,
		audiothrough_0_x1_neg_write
	);

	sendToHardware(
		b2 / a0,
		audiothrough_0_x2_write,
		audiothrough_0_x2_neg_write
	);
	
	sendToHardware(
		-1 * (a1 / a0),
		audiothrough_0_y1_write,
		audiothrough_0_y1_neg_write
	);
	
	sendToHardware(
		-1 * (a2 / a0),
		audiothrough_0_y2_write,
		audiothrough_0_y2_neg_write
	);


	// while(1){
	// 	int data = audiothrough_0_data_out_read();
	// 	printf("Data: %d \n", data);
	// }

	return 0;
}
