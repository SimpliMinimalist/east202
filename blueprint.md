# Project Blueprint

## Overview

A Flutter application for managing products and orders.

## Project Structure

The project follows a feature-based folder structure.

-   `lib/features/auth`: Authentication-related features.
-   `lib/features/orders`: Order management features.
    -   `lib/features/orders/search_orders`: Search functionality for orders.
-   `lib/features/profile`: User profile management.
-   `lib/features/store`: Store management features.
    -   `lib/features/store/add_product`: Feature for adding and editing products.
    -   `lib/features/store/providers`: Contains providers for the store feature.
    -   `lib/features/store/search_product`: Feature for searching products.
    -   `lib/features/store/store_setup`: Feature for setting up the store.

## Features Implemented

### Add/Edit Product Screen
-   Allows creating and editing products.
-   Image picker for adding up to 10 product images.
-   Fields for product name, price, category, stock, and description.
-   Character limit for product name and description fields is only shown on focus.
-   Ability to add product variants.
-   The master price and stock fields are hidden when product variants are added.
-   "Add Product Variants" button width is now based on its content and centered.
-   The icon for the "Add Product Variants" button changes from an add icon to an edit icon when variants are present.
-   Draft saving functionality.
-   Sale price functionality with a dedicated bottom sheet widget (`SalePriceBottomSheet`).
-   Display of the original price with a strikethrough when a sale price is active.
-   The strikethrough line and the text color for the original price are now the same.
-   "Add discount" button is disabled until a valid price is entered.
-   "Add discount" button text changes to "Edit discount" when a sale price is active.
-   Sale price input validation to ensure the sale price is less than the original price.
-   The "Done" button in the sale price bottom sheet is disabled if the validation fails.
-   The sale price is automatically cleared if the bottom sheet is dismissed with an invalid value.
-   The sale price bottom sheet is scroll-controlled to avoid keyboard overlap.
-   Corrected a typo from `_editedDitedProduct` to `_editedProduct`.
-   Preserves existing variant data when editing variants.

### Add Variants Screen

-   The "Save" button has been moved from the app bar to a bottom navigation bar for a consistent user experience.
-   The app bar title dynamically changes to "Edit Variants" when variants are being edited.

### Edit Variant Screen

-   **Delete Functionality**: Added a delete icon to the app bar. Tapping the icon shows a confirmation dialog before deleting the variant.
-   The "Save" button has been moved from the app bar to a bottom navigation bar, matching the design of the "Add Variants" and "Add Product" screens.
-   Reuses the `PriceInputField` from the add product screen, allowing for sale prices on individual variants.
-   Manages state for sale price, including the discount percentage calculation.
-   Uses the `SalePriceBottomSheet` for a consistent editing experience.
-   **Error Handling**: Displays an error message if the user tries to save without adding an image or a price.
-   **Empty Default Fields**: The price and stock fields are now initialized as empty strings if their initial values are 0, preventing the display of "0.00" or "0" by default.

### Variant List UI
-   **Delete Functionality**: Added a delete icon to each variant card, allowing for quick deletion from the list. A confirmation dialog is now shown before deleting a variant.
-   Removed the shadow effect from the variant cards in the product details screen.
-   Added a light border to maintain visual separation between the cards.
-   Displays the variant's image in the list.
-   **Displays the sale price, original price with strikethrough, and discount percentage in the `VariantsList` widget when a sale price is active.**
-   The delete icon in the variant list card has been moved slightly to the right to improve the layout.
-   The delete confirmation message in the `VariantsList` now matches the message in the `EditVariantScreen` for consistency.

### Category Field UI Fix
-   Corrected the height and alignment of the "Category" input field to match other text fields and ensure it expands dynamically as category chips are added.
-   Replaced the previous implementation with a `TextFormField` wrapped in a `GestureDetector` and an `AbsorbPointer`.
-   The `TextFormField` is set to `readOnly: true` and acts as a styled container.
-   The `Wrap` widget containing the category `Chip`s is placed inside the `prefixIcon` property of the `InputDecoration`.
-   Fixed a typo from `Listile` to `ListTile` in the category picker bottom sheet.

### Category Chip UI
-   Reduced the height of the category chips to make them more compact.

### Variant Image Picker
-   Allows users to add an image to each product variant.
-   Refactored `ProductImageHandler` to support a variable number of images and display error messages.
-   Updated the `maxImages` for the main product to 10 and for variants to 4.
-   Integrated into `EditVariantScreen` to allow picking up to 4 images for a variant.

### Shared Widgets
-   **`ClearableTextFormField`**: Added an `errorText` parameter to allow displaying validation errors.
-   **`PriceInputField`**: Updated to accept and display an `errorMessage`.
-   **`ProductImageHandler`**: Added an `isVariantGallery` property to change the UI and behavior when displaying variant images.

### Variant Image Gallery and Data Model Fixes

-   **Goal:** Implement a read-only image gallery on the main product page that displays all variant images. This involved fixing the product variant data model and updating all related widgets.
-   **Steps:**
    1.  **`product_variant_model.dart`:** Changed the `image` property from `String?` to `List<String> images` to support multiple images per variant.
    2.  **`edit_variant_screen.dart`:** Updated the screen to use the new `images` list, allowing users to add, remove, and save multiple images.
    3.  **`add_product_screen.dart`:** Implemented the `_getVariantImages` method to aggregate images from all variants. The `ProductImageHandler` now displays these images in a read-only gallery view when variants are present.
    4.  **`variants_list.dart`:** Fixed the widget to display the first image from the `images` list as the variant thumbnail.

### Real-time Variant Image Deletion

-   **Goal:** Enable real-time, synchronous deletion of variant images from the aggregated gallery view on the main product page.
-   **Steps:**
    1.  **`product_image_handler.dart`:**
        -   Added a new optional callback function, `onImageDeleted`, which is triggered when an image is removed.
        -   The `_removeImage` function now calls `onImageDeleted` if it's provided, allowing the parent widget to handle the deletion logic. Otherwise, it updates its internal state as before.
    2.  **`add_product_screen.dart`:**
        -   Implemented the `onImageDeleted` callback in the `ProductImageHandler` for the variant image gallery.
        -   Created a `_deleteVariantImage` method that finds the correct product variant and removes the specified image from its `images` list.
        -   This ensures that deleting an image from the main gallery immediately updates the underlying data model and refreshes the UI.

### Variant Image Label UI Refinement

-   **Goal:** Improve the UI of the variant image labels.
-   **Steps:**
    1.  **Display Variant Values:**
        -   **`product_image_handler.dart`:** Added an optional `imageLabels` parameter to display variant values in the image gallery.
        -   **`add_product_screen.dart` & `edit_variant_screen.dart`:** Updated to provide the appropriate labels to the `ProductImageHandler`.
    2.  **Adjust Label Width:**
        -   **`product_image_handler.dart`:** Modified the layout to ensure the label's background width fits the text content, preventing it from expanding to the full width of the image.

### Fix Variant Deletion Logic

-   **Goal:** Correctly handle variant deletion to prevent deleted variants from reappearing and resolve related errors.
-   **Steps:**
    1.  **`variant_model.dart`:** Added a `copyWith` method to the `VariantOption` class to resolve an `undefined_method` error.
    2.  **`add_product_screen.dart`:**
        -   Corrected the logic in the `_deleteVariant` method to properly update the underlying variant options.
        -   Fixed null-check errors that were occurring during the deletion process.
    3.  **Analysis and Verification:** Ran `analyze_files` to ensure all errors were resolved.
    4.  **Update `blueprint.md`:** Documented the bug fix and the steps taken to resolve the errors.
    5.  **Commit and Push:** Committing the final, corrected code to the repository.

### Delete All Variants Functionality

-   **Goal:** Add a delete icon to the app bar in the "Edit Product Variants" screen that allows the user to delete all variants after a confirmation.
-   **Steps:**
    1.  **`add_variants_screen.dart`:**
        -   Added a delete icon to the app bar, which is only visible when `isUpdating` is true.
        -   Implemented a `_showDeleteConfirmationDialog` to confirm the deletion of all variants.
        -   Created a `_deleteAllVariants` method to clear all variants and return an empty list to the previous screen.
    2.  **Update `blueprint.md`:** Documented the new delete all variants feature.
    3.  **Commit and Push:** Committing the changes to the repository.

### Preserve Variant Option Values on Deletion

-   **Goal:** Correct the variant deletion logic to ensure that deleting a specific `ProductVariant` does not remove the underlying option values (e.g., "Small", "Red") if they are still used by other variants.
-   **Steps:**
    1.  **`add_product_screen.dart`:** Modified the `_deleteVariant` method to only remove the selected `ProductVariant` from the list, without altering the `variants` (the `VariantOption` list).
    2.  **Update `blueprint.md`:** Documented this critical bug fix.
    3.  **Commit and Push:** Committing the corrected code to the repository.

### Variant Validation on Save
-   **Goal:** Ensure that all product variants have at least one image and a price before saving the product.
-   **Steps:**
    1.  **`add_product_screen.dart`:**
        -   Added a `_variantsErrorText` state variable to hold validation messages.
        -   Updated the `_attemptSave` method to validate that each product variant has at least one image and a price greater than zero.
        -   If validation fails, the `_variantsErrorText` is updated, and an error message is displayed below the "Edit Product Variants" button.
    2.  **Update `blueprint.md`:** Documented the new validation feature.
    3.  **Commit and Push:** Committing the changes to the repository.

## Current Change: Variant Bulk Editing

-   **Goal:** Allow users to apply the same image, price, and stock to all product variants from the "Edit Variant" screen using toggle switches.
-   **Steps:**
    1.  **Centralize State Management:**
        -   Managed the state of three toggles (`useSameImage`, `useSamePrice`, `useSameStock`) in `add_product_screen.dart`.

    2.  **Update `edit_variant_screen.dart`:**
        -   Added three new toggle switches for "Use same image for all variants," "Use same price for all variants," and "Use same number of stock."
        -   The screen receives the toggle states and `onChanged` callbacks from `add_product_screen.dart`.

    3.  **Implement Synchronization Logic in `add_product_screen.dart`:**
        -   **Toggle ON**: When a toggle is activated, a function copies the corresponding data (images, price, or stock) from the currently edited variant to all other variants.
        -   **Automatic Toggle OFF**: When a user manually edits a synchronized field (price, stock, or images) in `edit_variant_screen.dart`, a callback is triggered to set the corresponding toggle state to `false` in `add_product_screen.dart`, indicating the values are no longer in sync.

    4.  **Update `variants_list.dart`:**
        -   Modified the widget to accept the toggle states and callbacks from `add_product_screen.dart`.
        -   Updated the `onTap` action for each variant to pass these states and callbacks down to the `edit_variant_screen.dart`.

-   **Bug Fix: Toggle State Management**
    -   **Problem**: The toggle switches in the `EditVariantScreen` were not updating their visual state correctly, and the data synchronization was using the wrong variant's data.
    -   **Solution**:
        1.  **Local State in `EditVariantScreen`**: Added local state variables to `EditVariantScreen` to manage the toggles' UI, ensuring they update instantly.
        2.  **Corrected Data Sync**: Modified the `onChanged` callbacks to pass the currently edited variant's data back to `AddProductScreen`.
        3.  **Updated Sync Logic**: Updated the synchronization methods in `AddProductScreen` to use the data from the correct variant.
