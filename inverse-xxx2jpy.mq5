// Convert XXXYYY to YYYJPY.

// Example: USDZAR to ZARJPY
// Example: USDTRY to TRYJPY

#property indicator_separate_window

#property indicator_buffers 5
#property indicator_plots   1

#property indicator_label1 "Open;High;Low;Close"
#property indicator_type1  DRAW_COLOR_CANDLES
#property indicator_color1 White, OrangeRed, DodgerBlue
#property indicator_style1 STYLE_SOLID
#property indicator_width1 1

input string XXXJPY = "USDJPY";  // The symbol name of XXXJPY is

double open[];
double high[];
double low[];
double close[];
double clr[];
// buffers

int OnInit()
{
	SetIndexBuffer(0, open,  INDICATOR_DATA);
	SetIndexBuffer(1, high,  INDICATOR_DATA);
	SetIndexBuffer(2, low,   INDICATOR_DATA);
	SetIndexBuffer(3, close, INDICATOR_DATA);
	SetIndexBuffer(4, clr,   INDICATOR_COLOR_INDEX);

	return INIT_SUCCEEDED;
}

int OnCalculate(const int       RATES_TOTAL,
		const int       PREV_CALCULATED,
		const datetime &TIME[],
		const double   &OPEN[],
		const double   &HIGH[],
		const double   &LOW[],
		const double   &CLOSE[],
		const long     &TICK_VOLUME[],
		const long     &VOLUME[],
		const int      &SPREAD[])
{
	int n_xxxyyy;
	int n_xxxjpy;

	MqlRates a_xxxyyy[];
	MqlRates a_xxxjpy[];

	n_xxxyyy = CopyRates(Symbol(), Period(), 0, Bars(Symbol(), Period()),
			a_xxxyyy);
	n_xxxjpy = CopyRates(XXXJPY, Period(), 0, Bars(XXXJPY, Period()),
			a_xxxjpy);

	get_yyyjpy(a_xxxyyy, n_xxxyyy, a_xxxjpy, n_xxxjpy, RATES_TOTAL);

	return RATES_TOTAL;
}

void get_yyyjpy(const MqlRates &XXXYYY[], const int XXXYYY_N,
		const MqlRates &XXXJPY[], const int XXXJPY_N,
		const int N)
{
	if (XXXJPY_N < XXXYYY_N) {
		Print("not enough XXXJPY bars");
		return;
	}

	if (XXXYYY[XXXYYY_N - 1].time != XXXJPY[XXXJPY_N - 1].time) {
		Print("time lag error");
		return;
	}

	for (int i = 0; i < N; i++) {
		open[XXXYYY_N - N + i]  = XXXJPY[XXXJPY_N - N + i].open
				/ XXXYYY[XXXYYY_N - N + i].open;
		high[XXXYYY_N - N + i]  = XXXJPY[XXXJPY_N - N + i].high
				/ XXXYYY[XXXYYY_N - N + i].high;
		low[XXXYYY_N - N + i]   = XXXJPY[XXXJPY_N - N + i].low
				/ XXXYYY[XXXYYY_N - N + i].low;
		close[XXXYYY_N - N + i] = XXXJPY[XXXJPY_N - N + i].close
				/ XXXYYY[XXXYYY_N - N + i].close;

		if (open[XXXYYY_N - N + i] == close[XXXYYY_N - N + i]) {
			clr[XXXYYY_N - N + i] = 0.0;  // White
		} else if (open[XXXYYY_N - N + i] < close[XXXYYY_N - N + i]) {
			clr[XXXYYY_N - N + i] = 1.0;  // OrangeRed
		} else {
			clr[XXXYYY_N - N + i] = 2.0;  // DodgerBlue
		}
	}
}
