# Μάστορας Κωνσταντίνος 1115201900107

Το πρόγραμμα δυστυχώς **ΔΕΝ** υλοποιεί τις απαιτήσεις της εργασίας. Βγάζει αποτέλεσμα στο resuls, **ΑΛΛΑ** επειδή δεν καθαρίζει σωστά τη μνήμη συμβάντων, εμφανίζονται πλεονασματικά τα ίδια συμβάντα και καταστάσεις πολλές φορές.<br/>
Στην τρέχουσα μορφή περιέχει πολλες εντολές αποσφαλμάτωσης `write` (εμφανίζει πολλά μηνύματα κατά την εκτέλεση) καθώς προσπαθούσα να εντοπίσω το πρόβλημα.

## Event Calculus System

Αυτό το έργο περιέχει μια υλοποίηση Prolog ενός συστήματος event calculus με τη χρήση του πλαισίου SWI-Prolog. Το σύστημα επεξεργάζεται ορισμούς συμβάντων και κανόνες ορισμού σύνθετων καταστάσεων από αρχεία εισόδου. Παράγει αποτελέσματα με βάση ένα κυλιόμενο χρονικό παράθυρο.

### Προαπαιτούμενα
- Εγκατεστημένη τη γλώσσα SWI-Prolog στο σύστημά σας.
- Η δομή φακέλων του έργου με το `cerldi.prolog` και τον φάκελο `src/` και φακέλους δειγμάτων (π.χ. `samples/beers`, `samples/other_sample` κ.λπ.).

### Δομή Φακέλων
- `cerldi.prolog`: Main Prolog file.
- `src/` Source files folder.
- `samples/<sample>/`: Folders containing sample data.
  - `<sample>.input`: Input event stream file.
  - `definitions.prolog`: Definitions file for events and states.
  - `load.prolog`: Initialization file for loading dependencies.
- `results`: Output file (generated).

## Εκτέλεση

### Από την Γραμμή Εντολών
Μπορείτε να εκτελέσετε το πρόγραμμα χρησιμοποιώντας την SWI-Prolog με την παρακάτω εντολή:

```bash
swipl -q -s cerldi.prolog -g "['samples/beers/load.prolog'], er('samples/beers/beers.input', 'results', 'samples/beers/definitions.prolog', 20, 1), halt" -t "halt"
```

Μπορείτε να χρησιμοποιήσετε το αρχείο `run_beers.sh` δίνοντας στη γραμμή εντολών:<br/>
```bash
source run_beers.sh <window>> <step>
```

π.χ.:
```bash
source run_beers.sh 20 1
```
Αν έχετε κάποιο άλλο δείγμα όπως το beers π.χ. στον φάκελο `samples/<sample_folder>/` μπορείτε να χρησιμοποιήσετε το αρχείο `run_sample.sh` δίνοντας στη γραμμή εντολών:<br/>
```bash
source run_sample.sh <sample_folder> <window>> <step>
```
π.χ.:
```bash
source run_sample.sh other_sample 15 2
```
