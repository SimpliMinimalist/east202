# Project Blueprint

## Overview

A Flutter application for managing products and orders.

## Features Implemented

### Add/Edit Product Screen
-   Allows creating and editing products.
-   Image picker for adding up to 10 product images.
-   Fields for product name, price, category, stock, and description.
-   Ability to add product variants.
-   Draft saving functionality.

## Current Change: Refactor Sale Price Input

-   **Goal:** Improve the user experience for adding a discount by moving the sale price input to a more intuitive location.
-   **Steps:**
    1.  Remove the dedicated "Sale Price" text field from the main layout of the `add_product_screen.dart`.
    2.  Add a `TextButton` with the label "Add discount" inside the "Price" text field as a `suffixIcon`.
    3.  Implement a `showModalBottomSheet` that is triggered when the "Add discount" button is pressed.
    4.  The bottom sheet contains a `ClearableTextFormField` for the "Sale Price" and a "Done" button.
