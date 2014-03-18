#include <stdio.h>
#include <stdlib.h>
#include <time.h>

/* a - b in msecs */
static double timespec_sub(const struct timespec *a, const struct timespec *b) {
	long secs = a->tv_sec - b->tv_sec;
	long nanosecs = a->tv_nsec - b->tv_nsec;
	if (nanosecs < 0) {
		secs--;
		nanosecs += 1000000000L;
	}

	return secs * 1000 + nanosecs / 1000000.;
}


int main(int argc, char *argv[]) {
	if (argc != 4) {
		exit(1);
	}
	double f1 = atof(argv[1]);
	double f2 = atof(argv[2]);
	long iterations = atoi(argv[3]) * 1000 * 1000;
	double ans = 1.0;
	struct timespec start;
	int rc = clock_gettime(CLOCK_MONOTONIC, &start);
	if (rc < 0) {
		exit(1);
	}
	for (long i = 0; i < iterations; i++) {
		ans *= f1;
		ans /= f2;
		//if (i < 10)
		//	printf("%d ans = %f\n", i, ans);
	}
	struct timespec end;
	rc = clock_gettime(CLOCK_MONOTONIC, &end);
	if (rc < 0) {
		exit(1);
	}
	printf("ans = %f %ld loop/msec\n", ans, (long)(iterations / timespec_sub(&end, &start)));
	return 0;
}
