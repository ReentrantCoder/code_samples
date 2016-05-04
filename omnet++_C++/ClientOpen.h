#ifndef _ClientOpen_h_
#define _ClientOpen_h_

#include <stdio.h>
#include <string.h>
#include <omnetpp.h>
#include "WebRequest_m.h"
#include <vector>
#include <string>
#include <iostream>
#include <sstream>
#include <fstream>
#include <cmodule.h>

class ClientOpen : public cSimpleModule
{
private:
	double InterArrivalTime;
    std::ofstream output;

protected:
	virtual void initialize();
    virtual simtime_t getUtil(const char *node);
	virtual void handleMessage(cMessage *msg);
};
#endif