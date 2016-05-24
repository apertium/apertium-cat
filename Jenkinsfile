node {
   stage 'Checkout'
   checkout scm

   stage 'Build'
   sh "./autogen.sh && make clean && make"

   stage 'Validate Tagger Specification (tsx)'
   sh "apertium-validate-tagger apertium-cat-cat.tsx"
}
