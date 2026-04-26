# Vendor GUI 3 (vendorgui3)

This is a proof of concept solution based on GnuCOBOL 3.2 with VBISAM 2.1.1 and GTK3 for a master data maintenance application offering CRUD (create/read/update&delete) functionality and multi-user support.

The program manages a supplier/vendor database. It’s main focus is on simplicity,  following Einstein's maxim: "Everything should be as simple as possible, but not simpler.".

After starting the program this screen is presented:

![](img/image1.png)

Now you can either

* Enter an existing vendor number

* Enter a non-existing vendor number

* Leave the field vendor number empty

In the latter two cases the system will create a new vendor record. If you leave the field empty, the program will determine the next free vendor number first and then offer the vendor details screen.

 \
